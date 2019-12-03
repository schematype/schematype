require('pegex').require 'tree'

class SchemaTypeCompiler.AST extends Pegex.Tree
  initial: ->
    @schematype = {}
    @import = []
    @exports =
      like: []
      list: []
      must: []
      type: []

  final: ->
    schematype:
      spec: @schematype.version

  got_schematype_directive: (version)->
    @schematype.version = version
    return
