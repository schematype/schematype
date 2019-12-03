require('pegex').require 'grammar'

class SchemaTypeCompiler.Grammar extends Pegex.Grammar
  make_tree: ->
    {
       "+toprule" : "schema",
       "cl" : {
          ".rgx" : "(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\\z))"
       },
       "definition" : {
          ".any" : [
             {
                ".ref" : "type_definition"
             },
             {
                ".ref" : "pair_definition"
             },
             {
                ".ref" : "must_definition"
             },
             {
                ".ref" : "like_definition"
             },
             {
                ".ref" : "list_definition"
             }
          ]
       },
       "definitions" : {
          "+min" : 0,
          ".all" : [
             {
                ".ref" : "definition"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "desc_value" : {
          ".ref" : "xxx"
       },
       "directives" : {
          ".all" : [
             {
                "+min" : 0,
                ".ref" : "cl"
             },
             {
                ".ref" : "schematype_directive"
             },
             {
                "+min" : 0,
                ".ref" : "import_directive"
             }
          ]
       },
       "end" : {
          ".rgx" : "[\\ \\t]*(?:;|\\r?\\n|\\z)(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\\z))*"
       },
       "enum_expr" : {
          ".ref" : "xxx"
       },
       "import_directive" : {
          ".any" : [
             {
                ".ref" : "import_directive_group"
             },
             {
                ".ref" : "import_directive_single"
             }
          ]
       },
       "import_directive_group" : {
          ".all" : [
             {
                ".rgx" : "Import\\("
             },
             {
                "+min" : 0,
                ".ref" : "cl"
             },
             {
                ".all" : [
                   {
                      ".ref" : "import_target"
                   },
                   {
                      "+max" : 1,
                      ".ref" : "end"
                   }
                ]
             },
             {
                ".rgx" : "\\)"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "import_directive_single" : {
          ".all" : [
             {
                ".rgx" : "Import"
             },
             {
                "+min" : 1,
                ".ref" : "s"
             },
             {
                ".ref" : "import_target"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "import_target" : {
          ".any" : [
             {
                ".ref" : "import_target_core"
             },
             {
                ".ref" : "import_target_github"
             },
             {
                ".ref" : "import_target_http"
             }
          ]
       },
       "import_target_core" : {
          ".rgx" : "Core\\ +[0-9]+\\.[0-9]+\\.[0-9]+"
       },
       "import_target_github" : {
          ".ref" : "xxx"
       },
       "import_target_http" : {
          ".ref" : "xxx"
       },
       "like_definition" : {
          ".ref" : "xxx"
       },
       "like_expr" : {
          ".rgx" : "(//?)([^/]+)(//?)"
       },
       "list_definition" : {
          ".ref" : "xxx"
       },
       "list_properties" : {
          ".ref" : "xxx"
       },
       "must_definition" : {
          ".ref" : "xxx"
       },
       "must_expr" : {
          ".ref" : "xxx"
       },
       "op_assign" : {
          ".rgx" : ":?="
       },
       "pair_definition" : {
          ".ref" : "xxx"
       },
       "pair_set" : {
          ".ref" : "xxx"
       },
       "range_expr" : {
          ".ref" : "xxx"
       },
       "s" : {
          ".rgx" : "\\ "
       },
       "schema" : {
          ".all" : [
             {
                ".ref" : "directives"
             },
             {
                ".ref" : "definitions"
             }
          ]
       },
       "schematype_directive" : {
          ".rgx" : "SchemaType\\ +([0-9]+\\.[0-9]+\\.[0-9]+)[\\ \\t]*(?:;|\\r?\\n|\\z)(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\\z))*"
       },
       "size_expr" : {
          ".ref" : "xxx"
       },
       "type_base" : {
          ".rgx" : "(?:(?:Str|Int|Bool)|![a-z][\\-a-z0-9]*)"
       },
       "type_definition" : {
          ".any" : [
             {
                ".ref" : "type_definition_parens"
             },
             {
                ".ref" : "type_definition_line"
             },
             {
                ".ref" : "type_definition_bare"
             }
          ]
       },
       "type_definition_bare" : {
          ".all" : [
             {
                ".ref" : "type_name"
             },
             {
                "+min" : 0,
                ".ref" : "s"
             },
             {
                ".ref" : "op_assign"
             },
             {
                "+min" : 0,
                ".ref" : "s"
             },
             {
                ".ref" : "type_base"
             },
             {
                "+min" : 0,
                ".ref" : "s"
             },
             {
                "+max" : 1,
                ".ref" : "list_properties"
             }
          ]
       },
       "type_definition_line" : {
          ".all" : [
             {
                ".ref" : "type_name"
             },
             {
                "+min" : 0,
                ".ref" : "s"
             },
             {
                ".ref" : "op_assign"
             },
             {
                "+min" : 0,
                ".ref" : "s"
             },
             {
                ".ref" : "type_base"
             },
             {
                "+min" : 1,
                ".ref" : "s"
             },
             {
                ".ref" : "type_property"
             }
          ]
       },
       "type_definition_parens" : {
          ".all" : [
             {
                ".ref" : "type_name"
             },
             {
                "+min" : 0,
                ".ref" : "s"
             },
             {
                ".ref" : "op_assign"
             },
             {
                "+min" : 0,
                ".ref" : "s"
             },
             {
                ".ref" : "type_base"
             },
             {
                ".rgx" : "\\("
             },
             {
                ".ref" : "end"
             },
             {
                ".ref" : "type_property"
             },
             {
                ".ref" : "end"
             },
             {
                ".rgx" : "\\)"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "type_name" : {
          ".rgx" : "[a-z][\\-a-z0-9]*"
       },
       "type_property" : {
          ".any" : [
             {
                ".ref" : "pair_set"
             },
             {
                ".ref" : "must_expr"
             },
             {
                ".ref" : "like_expr"
             },
             {
                ".ref" : "enum_expr"
             },
             {
                ".ref" : "size_expr"
             },
             {
                ".ref" : "range_expr"
             },
             {
                ".ref" : "desc_value"
             }
          ]
       },
       "xxx" : {
          ".rgx" : "XXX"
       }
    }
