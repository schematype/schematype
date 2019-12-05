require '../schematype-compiler'
require '../schematype-compiler/grammar'
require '../schematype-compiler/ast'

require('pegex').require 'parser'

json_stringify = require 'json-stringify-pretty-compact'

parse_schematype = (schematype_input, schematype_file)->
  parser = new Pegex.Parser
    grammar: new SchemaTypeCompiler.Grammar
    receiver: new SchemaTypeCompiler.AST
      file: schematype_file
    debug: Boolean SchemaTypeCompiler.env.SCHEMATYPE_COMPILER_DEBUG

  parser.parse schematype_input

class SchemaTypeCompiler.Compiler
  ast: null

  compile: (schematype_input, schematype_file='-')->
    if SchemaTypeCompiler.env.SCHEMATYPE_COMPILER_GRAMMAR_PRINT
      grammar = new SchemaTypeCompiler.DevGrammar
      grammar.make_tree()
      say JSON.stringify grammar.tree, null, 2
      exit 0

    schematype_input.replace /\n?$/, '\n' if schematype_input.length

    @ast_to_json parse_schematype schematype_input, schematype_file

  ast_to_json: (ast)->
    json = json_stringify ast, {}
    json + "\n"
