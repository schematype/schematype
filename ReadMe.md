SchemaType
==========

SchemaType is a Data Type Definition Language

[![Build Status](https://travis-ci.org/schematype/schematype.svg?branch=master)](https://travis-ci.org/schematype/schematype)

# SchemaType Resources

* [SchemaType Website](http://schematype.org)
* [SchemaType Wiki](https://github.com/schematype/schematype/wiki)

# Synopsis
```
stp --validate foo.stp foo1.json foo2.yaml foo3.csv
stp --generate=jsonschema foo.stp
stp --generate=sql foo.stp
```

# Installation
Installing SchemaType is as simple as cloning the repo and sourcing a startup
file. Make sure you have the Prerequisites (see below) insalled first.

```
# Clone the SchemaType repository:
git clone https://github.com/schematype/schematype /path/to/schematype

# Add to your Bash or Zsh startup file:
source /path/to/schematype/.rc

# Or add to your Fish startup file:
source /path/to/schematype/.rc.fish

# For other POSIX shells:
SCHEMATYPE=/path/to/schematype
export SCHEMATYPE
source /path/to/schematype/.rc

# Test out the `stp` command:
stp --help

# Try out the man pages:
man schematype
man stp
```

## Prerequisites

You'll need Perl and NodeJS installed to build the SchemaType compiler. You'll
also need Git and Gnu Make. Otherwise all the dependencies should be bundled in
the repo.

See https://github.com/schematype/schematype/wiki/SchemaType-Requirements for
full details.

* Linux or OSX
  * Windows support is intended!
* Bash 4.4+
  * See URL above for Mac OS X concerns
* Git 2.7+
* Gnu Make 4.0+
* Perl 5.10+
* NodeJS 6.0+
* `curl` or `wget`

Optional:

* Docker 18.09.0+
  * For running tests with `make docker-test`

# Repository Layout

This repository has lots of independent parts each on their own branch.

The `master` branch only has a `ReadMe` and a `Makefile`.

# Development

To work with this repository, first run:
```
make work
make pull
make status
```

This will pull out all the parts (work) branches into worktree subdirectories,
and then run `git pull --rebase` on all of them.

Then try `make test`, which will run all the test suites.

## Work Branches

* `compiler` - The SchemaType reference compiler
* `doc` - Documentation and man pages
* `docker` - Support for testing in clean Docker environment
* `example` - Various SchemaType examples
* `grammar` - Parser grammar for the `stp` language
* `node_modules` - NodeJS dependencies
* `note` - Notes about the SchemaType project
* `perl5` - Perl5 dependencies
* `stp` - The `stp` commandline tool
* `test.compiler` - Compiler test suite

## Makefile Rules

* `make work` - Checkout all branches above into directories
* `make status` - Show git status of all the work branch dirs
* `make pull` - Do `git pull --rebase` on all work branch dirs

* `make clean` - Remove all generated files
* `make realclean` - Do `clean` and remove all the work dirs

* `make test` - Run test suite
* `make test-compiler` - Run the compiler test suite

* `make docker-test` - Run the test suite in a Docker container
* `make docker-shell` - Start a shell in the SchemaType Docker container

## Development Prerequisites

Some extra tools are needed to do all the development tasks:

* Pandoc 2.7+
  * Needed to make man pages
  * `make -C doc man`
