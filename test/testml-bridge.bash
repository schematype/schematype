#!/usr/bin/env bash

shopt -s inherit_errexit

TestMLBridge.run-out() (
  cmd=$1
  cd test
  export SCHEMATYPE_CACHE=$PWD/cache
  rm -fr "$SCHEMATYPE_CACHE"
  eval "$cmd" 2>&1 || true

  # XXX Hack until testml-bash can handle:
  # =>
  #   ...
  show_cache=$(TestML.block:$TestML_block:show-cache 2>/dev/null) || true
  if [[ $show_cache ]]; then
    echo
    ls -1 "$SCHEMATYPE_CACHE"
  fi
)

TestMLBridge.clean() {
  echo "$1" | sed 's/"time":.*/"time": "1234567890123",/'
}
