require('pegex').require 'grammar'

class SchemaTypeCompiler.Grammar extends Pegex.Grammar
  make_tree: ->
    {
       "+toprule" : "schema",
       "XXX" : {
          ".rgx" : "XXX"
       },
       "cl" : {
          ".rgx" : "(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$))"
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
          ".ref" : "XXX"
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
          ".rgx" : "(?:[\\ \\t]*(?:;[\\ \\t]*|\\r?\\n|\$|(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$)))(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$))*)"
       },
       "enum_expr" : {
          ".ref" : "XXX"
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
                "+min" : 0,
                ".ref" : "s"
             },
             {
                ".all" : [
                   {
                      ".ref" : "import_target"
                   },
                   {
                      "+min" : 0,
                      "-flat" : 1,
                      ".all" : [
                         {
                            ".ref" : "import_sep"
                         },
                         {
                            ".ref" : "import_target"
                         }
                      ]
                   },
                   {
                      "+max" : 1,
                      ".ref" : "import_sep"
                   }
                ]
             },
             {
                "+min" : 0,
                ".ref" : "s"
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
       "import_sep" : {
          ".rgx" : "(?:[\\ \\t]*(?:;[\\ \\t]*|\\r?\\n|\$|(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$)))(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$))*)[\\ \\t]*"
       },
       "import_target" : {
          ".any" : [
             {
                ".ref" : "import_target_core"
             },
             {
                ".ref" : "import_target_git"
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
          ".rgx" : "Core[\\ \\t]+([0-9]+\\.[0-9]+\\.[0-9]+)"
       },
       "import_target_git" : {
          ".rgx" : "git:([^\\s;\\)]+)[\\ \\t]+([^\\s;\\)]+)"
       },
       "import_target_github" : {
          ".rgx" : "github:(\\w+)/(\\w+)[\\ \\t]+([^\\s;\\)]+)"
       },
       "import_target_http" : {
          ".rgx" : "(https?://[^\\s;\\)]+)"
       },
       "like_definition" : {
          ".ref" : "XXX"
       },
       "like_expr" : {
          ".rgx" : "(//?)([^/]+)(//?)"
       },
       "list_definition" : {
          ".ref" : "XXX"
       },
       "list_properties" : {
          ".ref" : "XXX"
       },
       "must_definition" : {
          ".ref" : "XXX"
       },
       "must_expr" : {
          ".ref" : "XXX"
       },
       "op_assign" : {
          ".rgx" : ":?="
       },
       "pair_definition" : {
          ".ref" : "XXX"
       },
       "pair_set" : {
          ".ref" : "XXX"
       },
       "range_expr" : {
          ".ref" : "XXX"
       },
       "s" : {
          ".rgx" : "[\\ \\t]"
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
          ".rgx" : "SchemaType[\\ \\t]+([0-9]+\\.[0-9]+\\.[0-9]+)(?:[\\ \\t]+\\+([0-9]+\\.[0-9]+\\.[0-9]+))?(?:[\\ \\t]*(?:;[\\ \\t]*|\\r?\\n|\$|(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$)))(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$))*)"
       },
       "size_expr" : {
          ".ref" : "XXX"
       },
       "type_base" : {
          ".rgx" : "(?:(?:Str|Int|Bool|Map|Tuple)|![a-z][\\-a-z0-9]*)"
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
       }
    }
