require 'ingy-prelude'
require '../schematype-validator'

json_stringify = require 'json-stringify-pretty-compact'

class SchemaTypeValidator.Validator
  constructor: ->
    @message = []
    @path = []

  status: 0

  validate: (@schema, @type_name, @data_file='-')->
    @schema.show ||= []
    @schema.type ||= {}

    switch
      when @data_file.match /\.json$/
        @validate_json_file()
      else
        die "schematype-validate currently only supports JSON data files"

    if @message.length
      say "Found the following problems validating '#{@data_file}:"
      for message in @message
        say "* #{message}"
      return 1
    else
      return 0

  validate_json_file: ->
    node = JSON.parse file_read @data_file
    type = @get_type @type_name
    @validate_node node, type

  validate_node: (node, type)->
    if type.list?
      @validate_list node, type
    else
      switch type.kind
        when 'Map'  then @validate_map  node, type
        when 'Str'  then @validate_str  node, type
        when 'Int'  then @validate_int  node, type
        when 'Bool' then @validate_bool node, type
        else
          die "Unknown kind '#{type.kind}"

  validate_map: (node, type)->
    if not _.isObject node
      @err "Expected Map ..."
      return
    @check_map_keys node, type
    return

  validate_str: (node, type)->
    if not _.isString node
      @err "Expected Str ..."
      return

    if (like = type.like)? and not node.match like
      @err "'#{node}' does not match pattern /#{like}/ ..."

    if (enum_ = type.enum)? and not (node in enum_)
      @err "'#{node}' is not one of [#{_.toString enum_}] ..."

  validate_int: (node, type)->
    if not _.isInteger node
      @err "Expected Int ..."
      return

    if (xtoy = type.xtoy)? and node < xtoy[0] or node > xtoy[1]
      @err "#{node} is not in range '#{_.join type.xtoy, '..'}' ..."

  check_map_keys: (node, type)->
    type_map = {}

    for [key, type, required] in type.pair
      if required and not node[key]?
        @err "Expected Map key '#{key}' ..."
      type_map[key] = type

    for key, val of node
      if not type_map[key]?
        @err "Unexpected key '#{key}' ..."
        continue

      @path.push key
      @validate_node val, @get_type type_map[key]
      @path.pop()

  get_type: (ref)->
    if _.isString ref
      if ref == 'Main'
        if @schema.show.length = 1
          ref = @schema.show[0]
        else
          die "Can't determine 'Main' type"
      if ref.match /^!/
        ref = ref.substr 1

      if not @schema.type[ref]?
        xxx "Unknown type ref", ref

      return @schema.type[ref]

    else if _.isObject ref and ref.kind?
      return ref
    else
      xxx "Unknown type ref", ref

  err: (msg)->
    msg = msg.replace /\ \.\.\./, " at data path #{@get_path()}"
    @message.push msg

  get_path: ->
    '/' + _.join @path, '/'


# vim: sw=2:
