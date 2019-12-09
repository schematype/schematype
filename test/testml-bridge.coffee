require 'testml/bridge'
require 'schematype-compiler/compiler'
require 'ingy-prelude'

module.exports =
class TestMLBridge extends TestML.Bridge
  compile: (stp)->
    compiler = new SchemaTypeCompiler.Compiler
    stc = compiler.compile stp, 'test.stp'
    stc = stc.replace /"[0-9]{13}"/g, '"1234567890123"'
    stc = stc.replace /"[0-9a-f]{64}"/g,
      '"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"'
    stc

  add_head: (stp)->
    "SchemaType 0.1.0 +0.1.1\n" + stp

  clean: (stc)->
    stc = stc.replace /^[\{\}]$\n/mg, ''
    stc = stc.replace /^\ \ /mg, ''
    stc = stc.replace /^"SchemaType".*\n/mg, ''
    stc = stc.replace /^"from":\ \{[\s\S]*?\},?\n/mg, ''
    stc = stc.replace /^"with":\ \[.*\],?\n/mg, ''

# vim: sw=2:
