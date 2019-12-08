# Enable SchemaType framework for the Fish shell:

if not test -n "$FISH_VERSION"
  echo "Can't enable SchemaType for your shell with the '.rc.fish' file."
  echo
  echo "See: https://github.com/schematype/schematype/wiki/SchemaType-Setup"

  exit 1
end

set SCHEMATYPE_ROOT (cd (dirname (status --current-filename)); and pwd)

bash "$SCHEMATYPE_ROOT/.shell/check"; or begin
  set -e SCHEMATYPE_ROOT
  exit 1
end

if not begin; test -d "$SCHEMATYPE_ROOT/stp"; and test -d "$SCHEMATYPE_ROOT/doc"; end
  make -C "$SCHEMATYPE_ROOT" stp doc example >/dev/null 2>/dev/null; or begin
    echo "Failed to enable SchemaType"
    set -e SCHEMATYPE_ROOT
    exit 1
  end
end

export SCHEMATYPE_ROOT
set PATH $SCHEMATYPE_ROOT/stp/bin $PATH; export PATH
set MANPATH $SCHEMATYPE_ROOT/doc/man $MANPATH; export MANPATH
