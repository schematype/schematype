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
          ".ref" : "definition"
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
          ".all" : [
             {
                ".rgx" : "\\["
             },
             {
                "+min" : 0,
                ".ref" : "s"
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
                            "+min" : 0,
                            ".ref" : "s"
                         },
                         {
                            ".ref" : "wordlet"
                         }
                      ]
                   },
                   {
                      "+max" : 1,
                      "+min" : 0,
                      ".ref" : "s"
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
          ".rgx" : "\\+([1-9][0-9]*)"
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
                ".rgx" : "([a-z][\\-a-z0-9]*)[\\ \\t]*(:?=)[\\ \\t]*((?:(?:Str|Int|Bool|Map|Tuple)|![a-z][\\-a-z0-9]*))"
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
                ".rgx" : "([a-z][\\-a-z0-9]*)[\\ \\t]*(:?=)[\\ \\t]*((?:(?:Str|Int|Bool|Map|Tuple)|![a-z][\\-a-z0-9]*))"
             },
             {
                ".all" : [
                   {
                      "+min" : 1,
                      ".ref" : "s"
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
                ".rgx" : "([a-z][\\-a-z0-9]*)[\\ \\t]*(:?=)[\\ \\t]*((?:(?:Str|Int|Bool|Map|Tuple)|![a-z][\\-a-z0-9]*))\\("
             },
             {
                "+max" : 1,
                ".all" : [
                   {
                      ".all" : [
                         {
                            "+min" : 0,
                            ".ref" : "s"
                         },
                         {
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
                         }
                      ]
                   },
                   {
                      "+min" : 0,
                      "-flat" : 1,
                      ".all" : [
                         {
                            ".ref" : "end"
                         },
                         {
                            ".all" : [
                               {
                                  "+min" : 0,
                                  ".ref" : "s"
                               },
                               {
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
                               }
                            ]
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
                "+max" : 1,
                ".all" : [
                   {
                      ".ref" : "end"
                   },
                   {
                      ".all" : [
                         {
                            ".all" : [
                               {
                                  "+min" : 0,
                                  ".ref" : "s"
                               },
                               {
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
                               }
                            ]
                         },
                         {
                            "+min" : 0,
                            "-flat" : 1,
                            ".all" : [
                               {
                                  ".ref" : "end"
                               },
                               {
                                  ".all" : [
                                     {
                                        "+min" : 0,
                                        ".ref" : "s"
                                     },
                                     {
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
                                     }
                                  ]
                               }
                            ]
                         },
                         {
                            "+max" : 1,
                            ".ref" : "end"
                         }
                      ]
                   }
                ]
             },
             {
                ".rgx" : "\\)(?:[\\ \\t]*(?:;[\\ \\t]*|\\r?\\n|\$|(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$)))(?:[\\ \\t]*(?:\\#.*)?(?:\\r?\\n|\$))*)"
             }
          ]
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
       "wordlet" : {
          ".rgx" : "([^\\s\\]]+)"
       }
    }
