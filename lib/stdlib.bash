set -o errexit
set -o nounset
set -o pipefail
shopt -s inherit_errexit
shopt -s nullglob

check-bash-version() {
  if ! [[ $BASH_VERSION =~ ^(5\.|4\.4) ]]; then
    die "The SchemaType framework requires Bash 4.4 or higher" \
        "This is only Bash '$BASH_VERSION'" \
        "See: https://github.com/schematype/schematype/wiki/SchemaType-Requirements"
  fi
}

shasum() {
  if [[ $OSTYPE == darwin* ]]; then
    die 'XXX - shasum for mac'
  else
    sha256sum | cut -d' ' -f1
  fi
}

die() {
  if [[ $* ]]; then
    printf "%s\n" "$@"
  else
    echo Died
  fi
  exit 1
}

error() {
  die "Error: $*"
}
