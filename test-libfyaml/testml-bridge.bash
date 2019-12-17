TestMLBridge.run() {
  yaml=$1
  cmd=$2
  file=test.yaml
  echo "$yaml" > "$file"
  eval "$cmd"
  rm -f "$file"
}
