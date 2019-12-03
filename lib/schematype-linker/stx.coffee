require '../schematype-linker'

class SchemaTypeLinker.STX
  constructor: ->
    @SchemaType =
      spec: "0.1.0"
    @show = []
    @from = {}
    @with = []
    @type = {}
    @like = {}
    @list = {}
    @must = {}
    @pair = {}

  final: ->
    delete @show unless @show.length
    delete @from unless _.keys(@from).length
    delete @with unless @with.length
    for prop in ['from', 'type', 'like', 'list', 'must', 'pair']
      delete @[prop] unless _.keys(@[prop]).length
    @

  add_from: (from)->
    @from.name = from.name
    @from.time = String Math.floor new Date
    @from.mark = from.mark

  add_show: (@show=[])->



# vim: sw=2:
