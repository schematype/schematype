require 'ingy-prelude'
require '../schematype-linker'

json_stringify = require 'json-stringify-pretty-compact'

class SchemaTypeLinker.Linker
  link: (stp_input)->
    @stc = JSON.parse stp_input
    @err = []
    @tid = 1
    @type = {}

    @stx = {}
    @stx.SchemaType = @stc.SchemaType
    @stx.from = @stc.from
    @stx.from.time = String Math.floor new Date
    @stx.show = @stc.show if @stc.show?
    if @stc.type?
      @stx.type = {}
      for name, hash of @stc.type
        if type = @make_type(hash, {}, true)
          @stx.type[name] = type

      for k, v of @type
        @stx.type[k] = v

    @stx.like = @stc.like if @stc.like?
    @stx.list = @stc.list if @stc.list?
    @stx.pair = @stc.pair if @stc.pair?
    @stx.must = @stc.must if @stc.must?

    if @err.length
      throw @err

    (json_stringify @stx) + '\n'

  make_type: (hash, type, top=false)->
    if typeof hash == 'string'
      return hash
    type.kind = @get_kind hash
    delete hash.kind
    method = "make_#{type.kind}"
    type = @[method](hash, type)
    if top
      return type
    else
      name = type.kind + '-' + String @tid++
      @type[name] = type
      return "!#{name}"

  make_Map: (hash, type)->
    if not pairs = hash.pair
      return @error "No pairs defined Map type"
    type.pair = []
    for p in pairs
      pair = [
        @make_type p[0], {}
        @make_type p[1], {}
      ]
      pair.push true if p[2]?

      type.pair.push pair

    return type

  make_Int: (hash, type)->
    for k, v of hash
      type[k] = v
    return type

  make_Str: (hash, type)->
    for k, v of hash
      type[k] = v
    return type

  get_kind: (hash)->
    if hash.kind?
      return hash.kind
    if hash.like? or hash.enum?
      return 'Str'
    if hash.xtoy?
      return 'Int'
    xxx hash

  @error: (err)->
    @err.push err
    return false


# vim: sw=2:
