# this file defines functions or other things that are needed early
function has_command() {
  command -v "$@" >/dev/null 2>&1;
}

function is_windows() {
  [[ "$OSTYPE" == msys || "$OSTYPE" == cygwin ]]
}
