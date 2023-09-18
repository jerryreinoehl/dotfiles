# vim: ft=bash
# shellcheck shell=bash
# =============================================================================
# venv.sh
# v0.2.0
# =============================================================================

venv() {
  local REPLY

  local venv_path venv_name="venv" venv_prompt
  local -i create=0
  local -i deactivate=0
  local -i freeze=0
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
      -f) freeze=1 ;;
      -F) freeze=1; requirements_file="/dev/stdout" ;;
      -n) venv_name="$1" ;;
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
  (( ${#args[@]} > 1 )) && venv_name="${args[*]:1:1}"

  if (( deactivate )); then
    __venv_deactivate || rc=1
    return "$rc"
  fi

  if (( freeze )); then
    __venv_freeze "$requirements_file"
    return $?
  fi

  if [[ -z "$VIRTUAL_ENV" ]]; then
    if (( create )); then
      __venv_create \
        "$venv_name" "$venv_prompt" "$use_system_site_packages" || rc=1
    else
      __venv_activate_by_name "$venv_name" || rc=1
    fi
  fi

  if (( install_requirements )); then
    __venv_install_requirements "$requirements_file" || rc=1
  fi

  return "$rc"
}

__venv_search_venv_path() {
  local venv="$1"
  local base="$PWD"
  REPLY=""

  while [[ -n "$base" ]]; do
    [[ -r "$base/$venv/bin/activate" ]] && REPLY="$base/$venv" && return
    base="${base%/*}"
  done
}

__venv_activate_by_name() {
  local venv_name="$1"
  local venv_path
  local source_path

  __venv_search_venv_path "$venv_name"; venv_path="$REPLY"

  if [[ -z "$venv_path" ]]; then
    __venv_error "Unable to find venv: $venv_name"
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
  __venv_require_venv || return 1
  deactivate
}

__venv_create() {
  local venv_name="$1"
  local venv_prompt="$2"
  local -i use_system_site_packages="$3"
  local -a python_args
  local rc=0

  local msg="Creating venv: $venv_name..."
  echo -en "\e[1;36m==>\e[0;36m $msg\e[0m"

  [[ -n "$venv_prompt" ]] && python_args+=("--prompt" "$venv_prompt")
  (( use_system_site_packages )) && python_args+=("--system-site-packages")

  python -m venv "$venv_name" "${python_args[@]}"
  __venv_activate "$venv_name" || rc=1

  echo -en "\e[2K\r" # Clear line

  return "$rc"
}

__venv_install_requirements() {
  local requirements_file="$1"

  __venv_require_venv || return 1

  if [[ ! -r "$requirements_file" ]]; then
    __venv_error "Unable to read requirements file: $requirements_file"
    return 1
  fi

  __venv_info "Installing requirements..."
  pip install -r "$requirements_file"
}

__venv_freeze() {
  local requirements_file="$1"
  pip freeze > "$requirements_file"
  return $?
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
