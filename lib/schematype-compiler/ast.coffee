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
    @with = []
    @show = []

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

    @ast.with = @with if @with.length > 0
    @ast.show = @show if @show.length > 0

    @regex_interpolation()

    @ast.type = @type if _.keys(@type).length
    @ast.like = @like if _.keys(@like).length

    return @ast

  got_schematype_directive: ([version, core_version])->
    @schematype.version = version
    if core_version
      @got_import_target_core core_version

  got_import_target_core: (version)->
    @with.push ["github", "schematype/schematype", "type/" + version, "./core/"]

  got_import_target_github: ([user, repo, ref])->
    @with.push ["github", "#{user}/#{repo}", ref, "./"]

  got_import_target_git: ([repo, ref])->
    @with.push ["git", repo, ref, "./"]

  got_import_target_http: (url)->
    if url.match /\/$/
      file = 'index.stx'
    else
      m = url.match /.*\/(.*)/ or die()
      file = m[1] + '.stx'
      url = url.replace /(.*\/).*/, "$1"
    @with.push ["http", url, file]

  got_import_target_local: (path)->
    if path.match /\/$/
      file = 'index.stx'
    else
      m = path.match /.*\/(.*)/ or die()
      file = m[1] + '.stx'
      path = path.replace /(.*\/).*/, "$1"
    @with.push ["local", path, file]

  #----------------------------------------------------------------------------
  got_definition: ([[name, op], [sigil, value]])->
    switch sigil
      when "!" then @type[name] = value
      when "/" then @like[name] = value
      else die 'oops'

    if op == ':='
      @show.push sigil + name

  got_type_definition: ([base, got...])->
    props = _.assign {}, (@flat got)...
    @make_type props, base

  got_type_definition_baseless: (got)->
    props = _.assign {}, (@flat got)...
    @make_type props

  make_type: (props, base=null)->
    type = {}
    if base
      if base[0] == '!'
        type.base = base
      else
        type.kind = base
    for k in ['kind', 'pair', 'enum', 'like', 'smin', 'smax', 'xtoy']
      type[k] = props[k] if _.has props, k
    return ['!', type]

  got_like_definition: ([got...])->
    got = _.assign {}, (@flat got)...
    like = got.like
    return ['/', like]

  got_pair_expr: ([need, key, [sigil, value]])->
    pair = [key, value]
    pair.push true if need == '+'
    @pair[@pair.length - 1].push pair

  got_enum_expr: (got)->
    enum: @flat got

  got_like_expr: (got)->
    regex = got.replace /\r?\n/g, ' '
    regex = regex.replace /^\ /, '\\A'
    regex = regex.replace /\ $/, '\\z'
    regex = regex.replace /\(:/g, '(?:'
    regex = regex.replace /\s/g, ''
    like: regex

  got_xtoy_expr: ([x, y])->
    xtoy: [x, y]

  got_smin_expr: (got)->
    smin: Number got

  got_smax_expr: (got)->
    smax: Number got

  got_wordlet: (got)->
    got

  got_open: ->
    @pair.push []

  got_close: ->
    pair = @pair.pop()
    if pair.length
      return pair: pair

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
