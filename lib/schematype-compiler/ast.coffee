require('pegex').require 'tree'

class SchemaTypeCompiler.AST extends Pegex.Tree
  initial: ->
    @schematype = {}
    @imports = []
    @exports =
      like: []
      list: []
      must: []
      type: []

  final: ->
    ast = schematype:
      spec: @schematype.version
    ast.from = @imports if @imports.length > 0
    ast

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
