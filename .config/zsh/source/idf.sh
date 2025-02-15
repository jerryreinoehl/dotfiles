# =============================================================================
# Creates the `idf` command if esp-idf is installed.
#
# `idf` is just an alias for `idf.py` but will also source the esp-idf
# environment if not already done so (by checking if `IDF_PATH` has been set).
# =============================================================================

[[ ! -r /opt/esp-idf/export.sh ]] && return

idf() {
  [[ -z $IDF_PATH ]] && source /opt/esp-idf/export.sh
  idf.py "$@"

  # Redefine `idf` to skip check for `IDF_PATH`.
  idf() {
    idf.py "$@"
  }
}
