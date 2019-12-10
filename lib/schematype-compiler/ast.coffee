require('pegex').require 'tree'
crypto = require 'crypto'
secret = 'SchemaType 0.1.0'

class SchemaTypeCompiler.AST extends Pegex.Tree
  constructor: (args)->
    super args
    @name = args.file
    @mark = crypto.createHmac('sha256', secret)
      .update(args.text)
      .digest('hex')

  initial: ->
    @schematype = {}
    @imports = []
    @exports = []

    @type = {}
    @like = {}
    @pair = []

  final: ->
    @ast =
      SchemaType:
        spec: @schematype.version
      from:
        name: @name
        time: String Math.floor new Date
        mark: @mark

    @ast.with = @imports if @imports.length > 0
    @ast.show = @exports if @exports.length > 0

    @regex_interpolation()

    @ast.type = @type if _.keys(@type).length
    @ast.like = @like if _.keys(@like).length

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
  got_open: ->
    @pair.push []

  got_close: ->
    pair = @pair.pop()
    if pair.length
      return pair: pair
    else
      return

  got_type_definition: ([[name, op, base], got...])->
    got = _.assign {}, (@flat got)...
    type = {}
    if base[0] == '!'
      type.base = base
    else
      type.kind = base
    for k in ['kind', 'pair', 'enum', 'like', 'size', 'xtoy']
      type[k] = got[k] if _.has got, k
    @type[name] = type
    if op == ':='
      @exports.push '!' + name

  got_like_definition: ([[name, op], got...])->
    got = _.assign {}, (@flat got)...
    @like[name] = got.like
    if op == ':='
      @exports.push '/' + name

  got_pair_def: ([need, got])->
    pair = @flat got
    pair.push true if need == '+'
    @pair[@pair.length - 1].push pair

  got_enum_expr: (got)->
    enum: @flat got

  got_like_expr: (got)->
    [head, regex, foot] = @flat got
    regex = regex.replace /\(:/g, '(?:'
    regex = regex.replace /\s/g, ''
    regex = "\\A#{regex}" if head == '//'
    regex = "#{regex}\\z" if foot == '//'
    like: regex

  got_xtoy_expr: ([x, y])->
    xtoy: [x, y]

  got_size_expr: (got)->
    size: Number got

  got_wordlet: (got)->
    got

  #----------------------------------------------------------------------------
  flat: (array)->
    _.flattenDeep array

  regex_interpolation: ->
    for k, v of @type
      if v.like?
        v.like = v.like.replace /\{(\w+)\}/g, (m...)=>
          if @like[m[1]]?
            return @like[m[1]]
          else
            return m[0]

# vim: sw=2:
