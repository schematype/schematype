require 'testml/bridge'
require 'schematype-validator/validator'
require 'ingy-prelude'

module.exports =
class TestMLBridge extends TestML.Bridge
  validate_json: (stx, json)->
    schema = JSON.parse stx
    data = JSON.parse json
    validator = new SchemaTypeValidator.Validator
    validator.validate schema, data

    "OK"


# vim: sw=2:
