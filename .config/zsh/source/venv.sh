# vim: ft=bash
# shellcheck shell=bash
# =============================================================================
# venv.sh
# v0.3.0
# =============================================================================

if [[ -n $XDG_CACHE_HOME ]]; then
  VENV_HOME="${VENV_HOME:-$XDG_CACHE_HOME/venv}"
else
  VENV_HOME="${VENV_HOME:-$HOME/.cache/venv}"
fi

[[ ! -r $VENV_HOME ]] && mkdir -p "$VENV_HOME"

venv() {
  local REPLY

  local venv_path venv_prompt
  local -i create=0
  local -i deactivate=0
  local -i delete=0
  local -i freeze=0
  local -i show_info=0
  local -i install_requirements=0
  local -i use_system_site_packages=0
  local arg
  local -a args

  local requirements_file="requirements.txt"

  local -i rc=0

  while (( $# > 0 )); do
    arg="$1"; shift
    case "$arg" in
      -c) create=1 ;;
      -d) deactivate=1 ;;
      --delete) delete=1 ;;
      -f) freeze=1 ;;
      -F) freeze=1; requirements_file="/dev/stdout" ;;
      -i) show_info=1 ;;
      -r) install_requirements=1 ;;
      -R)
        install_requirements=1
        (( $# > 0 )) && requirements_file="$1" && shift
        ;;
      -s) use_system_site_packages=1 ;;
      *) args+=("$arg") ;;
    esac
  done

  venv_prompt="${args[*]:0:1}"

  if (( deactivate )); then
    __venv_deactivate
    return $?
  fi

  if (( delete )); then
    __venv_delete
    return $?
  fi

  if (( freeze )); then
    __venv_freeze "$requirements_file"
    return $?
  fi

  if (( show_info )); then
    __venv_show_info
    return $?
  fi

  if [[ -z "$VIRTUAL_ENV" ]]; then
    if (( create )); then
      __venv_create "$venv_prompt" "$use_system_site_packages" || rc=$?
    else
      __venv_activate_by_name || rc=$?
    fi
  fi

  if (( install_requirements )); then
    __venv_install_requirements "$requirements_file" || rc=$?
  fi

  return $rc
}

__venv_search_venv_path() {
  local base="$PWD"
  local venv_path
  REPLY=""

  while [[ -n "$base" ]]; do
    read -r -d ' ' venv_path <<< "$(sha256sum <<< "$base")"
    venv_path="$VENV_HOME/$venv_path"

    [[ -r "$venv_path/bin/activate" ]] && REPLY="$venv_path" && return
    base="${base%/*}"
  done
}

__venv_activate_by_name() {
  local venv_path
  local source_path
  local REPLY

  __venv_search_venv_path; venv_path="$REPLY"

  if [[ -z "$venv_path" ]]; then
    __venv_error "Unable to find venv"
    return 1
  fi

  __venv_activate "$venv_path"
}

__venv_activate() {
  local source_path="$1/bin/activate"

  if [[ ! -r "$source_path" ]]; then
    __venv_error "Unable to activate venv: $source_path"
    return 1
  fi

  # shellcheck disable=SC1090
  source "$source_path"
}

__venv_deactivate() {
  __venv_require_venv || return $?
  deactivate
}

__venv_create() {
  local venv_prompt="$1"
  local -i use_system_site_packages="$2"
  local venv_path
  local -a python_args
  local rc=0

  read -r -d ' ' venv_path <<< "$(sha256sum <<< "$PWD")"
  venv_path="$VENV_HOME/$venv_path"

  [[ -z $venv_prompt ]] && venv_prompt="${PWD##*/}"

  local msg="Creating venv: $venv_prompt..."
  echo -en "\e[1;36m==>\e[0;36m $msg\e[0m"

  [[ -n "$venv_prompt" ]] && python_args+=("--prompt" "$venv_prompt")
  (( use_system_site_packages )) && python_args+=("--system-site-packages")

  python -m venv "$venv_path" "${python_args[@]}"
  __venv_activate "$venv_path" || rc=1

  echo -en "\e[2K\r" # Clear line

  return "$rc"
}

__venv_install_requirements() {
  local requirements_file="$1"

  __venv_require_venv || return $?

  if [[ ! -r "$requirements_file" ]]; then
    __venv_error "Unable to read requirements file: $requirements_file"
    return 1
  fi

  __venv_info "Installing requirements..."
  pip install -r "$requirements_file"
}

__venv_delete() {
  local venv_path
  local REPLY

  __venv_search_venv_path; venv_path="$REPLY"

  if [[ -z $venv_path ]]; then
    __venv_error "Not in a virtual environment."
    return 1
  fi

  [[ -n $VIRTUAL_ENV ]] && __venv_deactivate
  rm -rf "$venv_path"
  return $?
}

__venv_freeze() {
  local requirements_file="$1"
  pip freeze > "$requirements_file"
  return $?
}

__venv_show_info() {
  local venv_path
  local venv_active_state
  local keyval_fmt="\e[1;36m%s\e[0m\e[36m = %s\e[0m\n"
  local -i rc=0
  local REPLY

  [[ -n $VIRTUAL_ENV ]] && venv_active_state="true" || venv_active_state="false"
  __venv_search_venv_path; venv_path="$REPLY"

  # shellcheck disable=SC2059
  if [[ -n $venv_path ]]; then
    printf "$keyval_fmt" "active" "$venv_active_state"
    printf "$keyval_fmt" "path  " "$venv_path"
  else
    __venv_error "Not in a virtual environment."
    rc=1
  fi

  return $rc
}

__venv_error() {
  local msg="$1"
  echo -e "\e[1;31m==>\e[0;31m $msg\e[0m"
}

__venv_info() {
  local msg="$1"
  echo -e "\e[1;36m==>\e[0;36m $msg\e[0m"
}

__venv_require_venv() {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    __venv_error "Not in a virtual environment."
    return 1
  fi
}
