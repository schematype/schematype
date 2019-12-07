require 'testml/bridge'
require 'schematype-compiler/compiler'
require 'ingy-prelude'

module.exports =
class TestMLBridge extends TestML.Bridge
  compile: (stp)->
    compiler = new SchemaTypeCompiler.Compiler
    compiler.compile(stp)

  add_head: (stp)->
    "SchemaType 0.1.0 +0.1.1\n" + stp

  clean: (stc)->
    stc = stc.replace /^[\{\}]$\n/mg, ''
    stc = stc.replace /^\ \ "/mg, '"'
    stc = stc.replace /^"(schematype|from)".*\n/mg, ''

# vim: sw=2:
