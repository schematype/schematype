require('pegex').require 'grammar'

class SchemaTypeCompiler.Grammar extends Pegex.Grammar
  make_tree: ->
    {
       "+toprule" : "schema",
       "XXX" : {
          ".rgx" : "XXX"
       },
       "_" : {
          ".rgx" : "(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*"
       },
       "__" : {
          ".rgx" : "(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))+"
       },
       "close" : {
          ".rgx" : "\\)"
       },
       "definition" : {
          ".all" : [
             {
                ".rgx" : "([a-z][\\-a-z0-9]*)[\\ \\t]*(:?=)(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*"
             },
             {
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
             }
          ]
       },
       "definitions" : {
          "+min" : 0,
          ".ref" : "definition"
       },
       "desc_expr" : {
          ".ref" : "XXX"
       },
       "directives" : {
          ".all" : [
             {
                ".ref" : "_"
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
          ".rgx" : "(?:[\\ \\t]*(?:;|(?:\\r?\\n|\$)|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*)"
       },
       "enum_expr" : {
          ".all" : [
             {
                ".rgx" : "\\[(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*"
             },
             {
                ".all" : [
                   {
                      ".ref" : "wordlet"
                   },
                   {
                      "+min" : 0,
                      "-flat" : 1,
                      ".all" : [
                         {
                            ".ref" : "__"
                         },
                         {
                            ".ref" : "wordlet"
                         }
                      ]
                   },
                   {
                      "+max" : 1,
                      ".ref" : "__"
                   }
                ]
             },
             {
                ".rgx" : "\\]"
             }
          ]
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
                ".rgx" : "Import\\((?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*"
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
                            ".ref" : "end"
                         },
                         {
                            ".ref" : "import_target"
                         }
                      ]
                   },
                   {
                      "+max" : 1,
                      ".ref" : "end"
                   }
                ]
             },
             {
                ".rgx" : "(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*\\)"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "import_directive_single" : {
          ".all" : [
             {
                ".rgx" : "Import[\\ \\t]+"
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
                ".ref" : "import_target_git"
             },
             {
                ".ref" : "import_target_github"
             },
             {
                ".ref" : "import_target_http"
             },
             {
                ".ref" : "import_target_local"
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
       "import_target_local" : {
          ".rgx" : "(\\./[^\\s;\\)]+)"
       },
       "like_definition" : {
          ".all" : [
             {
                ".ref" : "like_expr"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "like_expr" : {
          ".rgx" : "(//?)([^/]+)(//?)"
       },
       "list_definition" : {
          ".all" : [
             {
                ".ref" : "list_expr"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "list_expr" : {
          ".ref" : "XXX"
       },
       "list_properties" : {
          ".ref" : "XXX"
       },
       "must_definition" : {
          ".all" : [
             {
                ".ref" : "must_expr"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "must_expr" : {
          ".ref" : "XXX"
       },
       "open" : {
          ".rgx" : "\\((?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*"
       },
       "pair_definition" : {
          ".all" : [
             {
                ".ref" : "pair_expr"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "pair_expr" : {
          ".all" : [
             {
                ".ref" : "pair_marker"
             },
             {
                ".ref" : "pair_key"
             },
             {
                ".rgx" : "(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))+=\\>(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))+"
             },
             {
                ".ref" : "type_definition"
             }
          ]
       },
       "pair_key" : {
          ".rgx" : "(\\w[\\w\\.\\-]*|\"(?:\\\\\"|[^\"])*\")"
       },
       "pair_marker" : {
          ".rgx" : "(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*([\\+\\-])(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))+"
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
          ".rgx" : "SchemaType[\\ \\t]+([0-9]+\\.[0-9]+\\.[0-9]+)(?:[\\ \\t]+\\+([0-9]+\\.[0-9]+\\.[0-9]+))?(?:[\\ \\t]*(?:;|(?:\\r?\\n|\$)|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))(?:[\\ \\t\\n\\r]|(?:[\\ \\t]*\\#.*(?:\\r?\\n|\$)))*)"
       },
       "size_expr" : {
          ".rgx" : "\\+([1-9][0-9]*)"
       },
       "type_definition" : {
          ".any" : [
             {
                ".ref" : "type_definition_line"
             },
             {
                ".ref" : "type_definition_parens"
             },
             {
                ".ref" : "type_definition_bare"
             }
          ]
       },
       "type_definition_bare" : {
          ".all" : [
             {
                ".rgx" : "((?:(?:Str|Int|Bool|Map|Tuple|List)|![a-z][\\-a-z0-9]*))"
             },
             {
                "+max" : 1,
                ".ref" : "list_properties"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "type_definition_line" : {
          ".all" : [
             {
                ".rgx" : "((?:(?:Str|Int|Bool|Map|Tuple|List)|![a-z][\\-a-z0-9]*))[\\ \\t]+"
             },
             {
                "+max" : 1,
                ".all" : [
                   {
                      ".ref" : "type_property"
                   },
                   {
                      "+min" : 0,
                      "-flat" : 1,
                      ".all" : [
                         {
                            "+min" : 1,
                            ".ref" : "s"
                         },
                         {
                            ".ref" : "type_property"
                         }
                      ]
                   }
                ]
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "type_definition_parens" : {
          ".all" : [
             {
                ".rgx" : "((?:(?:Str|Int|Bool|Map|Tuple|List)|![a-z][\\-a-z0-9]*))"
             },
             {
                ".ref" : "open"
             },
             {
                "+min" : 0,
                ".all" : [
                   {
                      ".ref" : "type_property"
                   },
                   {
                      ".ref" : "_"
                   }
                ]
             },
             {
                ".ref" : "close"
             },
             {
                ".ref" : "end"
             }
          ]
       },
       "type_property" : {
          ".any" : [
             {
                ".ref" : "pair_expr"
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
                ".ref" : "xtoy_expr"
             },
             {
                ".ref" : "desc_expr"
             }
          ]
       },
       "wordlet" : {
          ".rgx" : "([^\\s\\]]+)"
       },
       "xtoy_expr" : {
          ".rgx" : "([0-9]+)\\.\\.([0-9]+)"
       }
    }
