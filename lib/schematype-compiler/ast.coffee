require('pegex').require 'tree'

class SchemaTypeCompiler.AST extends Pegex.Tree
  initial: ->
    @schematype = {}
    @imports = []
    @exports = []

    @vars = {}
    @re = {}

  final: ->
    @ast =
      schematype:
        spec: @schematype.version

    @ast.from = @imports if @imports.length > 0
    @ast.show = @exports if @exports.length > 0

    @regex_interpolation()

    _.assign @ast, @vars

    return @ast

  got_schematype_directive: ([version, core_version])->
    @schematype.version = version
    if core_version
      @got_import_target_core core_version
    return

  got_import_target_core: (version)->
    @imports.push [
      "github"
      "schematype/schematype"
      "type/" + version
      "./core/"
    ]
    return

  got_import_target_github: ([user, repo, ref])->
    @imports.push [
      "github"
      "#{user}/#{repo}"
      ref
      "./"
    ]
    return

  got_import_target_git: ([repo, ref])->
    @imports.push [
      "git"
      repo
      ref
      "./"
    ]
    return

  got_import_target_http: (url)->
    if url.match /\/$/
      file = 'index.stx'
    else
      m = url.match /.*\/(.*)/ or die()
      file = m[1] + '.stx'
      url = url.replace /(.*\/).*/, "$1"
    @imports.push [
      "http"
      url
      file
    ]
    return

  got_import_target_local: (path)->
    if path.match /\/$/
      file = 'index.stx'
    else
      m = path.match /.*\/(.*)/ or die()
      file = m[1] + '.stx'
      path = path.replace /(.*\/).*/, "$1"
    @imports.push [
      "local"
      path
      file
    ]
    return

  #----------------------------------------------------------------------------
  got_type_definition: ([[name, op, base], got...])->
    got = _.assign {}, (_.flattenDepth got, 9)...
    type = {}
    if base[0] == '!'
      type.base = base
    else
      type.kind = base
    for k in ['kind', 'type', 'enum', 'like', 'size']
      type[k] = got[k] if _.has got, k
    name = '!' + name
    @exports.push name if op == ':='
    @vars[name] = type

  got_like_definition: ([[name, op], got...])->
    got = _.assign {}, (_.flattenDepth got, 9)...
    regex = got.like
    @re[name] = regex
    name = '/' + name
    @exports.push name if op == ':='

  got_enum_expr: (got)->
    enum: _.flattenDepth got, 9

  got_like_expr: (got)->
    [head, regex, foot] = _.flattenDepth got, 9
    regex = regex.replace /\(:/g, '(?:'
    regex = regex.replace /\s/g, ''
    regex = "\\A#{regex}" if head == '//'
    regex = "#{regex}\\z" if foot == '//'
    like: regex

  got_size_expr: (got)->
    size: Number got

  got_wordlet: (got)->
    got

  #----------------------------------------------------------------------------
  regex_interpolation: ->
    for k, v of @vars
      if k[0] == '!'
        if v.like?
          v.like = v.like.replace /\{(\w+)\}/g, (m...)=>
            if @re[m[1]]?
              return @re[m[1]]
            else
              return m[0]

    for k, v of @re
      @vars["/#{k}"] = v

# vim: sw=2:
