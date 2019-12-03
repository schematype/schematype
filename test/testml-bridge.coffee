require 'testml/bridge'
require 'schematype-linker/linker'
require 'ingy-prelude'

module.exports =
class TestMLBridge extends TestML.Bridge
  link: (stc)->
    linker = new SchemaTypeLinker.Linker
    stx = linker.link stc, 'test.stp'
    stx = stx.replace /"[0-9]{13}"/g, '"1234567890123"'
    stx = stx.replace /"[0-9a-f]{64}"/g,
      '"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"'
    stx

  clean: (stx)->
    stx = stx.replace /^[\{\}]$\n/mg, ''
    stx = stx.replace /^\ \ /mg, ''
    stx = stx.replace /^"SchemaType".*\n/mg, ''
    stx = stx.replace /^"from":\ \{[\s\S]*?\},?\n/mg, ''
    stx = stx.replace /^"with":\ \[.*\],?\n/mg, ''
    stx = stx.replace /^\ *[\]\}],?\n/mg, ''
    stx = stx.replace /,$/mg, ''

  clean2: (stx)->
    stx = @clean(stx)
    stx = stx.replace /^"show":.*\n/mg, ''


# vim: sw=2:
