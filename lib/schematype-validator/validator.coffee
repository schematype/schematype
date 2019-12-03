require 'ingy-prelude'
require '../schematype-validator'

json_stringify = require 'json-stringify-pretty-compact'

class SchemaTypeValidator.Validator
  constructor: ->
    @status = 0
    @message = []

  status: 0

  validate: (schema, data_file='-')->
    status = 1 if @message.length

  write_output: ->
    say "OK"

# vim: sw=2:
