#!/usr/bin/env coffee

module.paths.unshift "#{require('path').dirname(__dirname)}/lib"

require 'ingy-prelude'
require 'pegex/lib/pegex/compiler'

# XXX Currently broken on the SchemaType grammar.
input = file_read '-'
input = """
x: / foo bar /
foo: 'x'
bar: 'y'
"""

compiler = new Pegex.Compiler

compiler.parse(input).combinate()

json = compiler.to_json()

say json
