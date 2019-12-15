#!/usr/bin/env bash

TestMLBridge.run-out() (
  cmd=$1
  cd test
  export SCHEMATYPE_CACHE=$PWD/cache
  rm -fr "$SCHEMATYPE_CACHE"
  eval "$cmd" 2>&1
)

TestMLBridge.clean() {
  echo "$1" | sed 's/"time":.*/"time": "1234567890123",/'
}
