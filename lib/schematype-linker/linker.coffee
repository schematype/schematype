require 'ingy-prelude'
require '../schematype-linker'
require '../schematype-linker/stx'

json_stringify = require 'json-stringify-pretty-compact'

class SchemaTypeLinker.Linker
  stx: new SchemaTypeLinker.STX

  link: (stp_input, stp_file='-')->
    @stc = JSON.parse stp_input

    @stx.add_from @stc.from
    @stx.add_show @stc.show

    @stx_to_json @stx.final()

  stx_to_json: (stx)->
    json = json_stringify stx, {}
    json + "\n"
