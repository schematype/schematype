SchemaType
==========

SchemaType is a Data Type Definition Language

# SchemaType Resources

* [SchemaType Website](http://schematype.org)
* [SchemaType Wiki](https://github.com/schematype/schematype/wiki)

# Repository Layout

This repository has lots of independent parts each on their own branch.

The `master` branch only has a `ReadMe` and a `Makefile`.

# Development

To work with this repository, first run:
```
make work
make pull
```

This will pull out all the parts (work) branches into worktree subdirectories,
and then run `git pull --rebase` on all of them.

Then try `make test`, which will run all the test suites.

## Prerequisites

You'll need Perl and NodeJS installed to build the SchemaType compiler. You'll
also need Git and Gnu Make. Otherwise all the dependencies should be bundled in
the repo.

* Linux or OSX
* Perl 5.10+
* NodeJS 6.0+
* Bash 3.2+
* Git 2.0+
* Gnu Make

Optionally you can run tests in Docker with `make docker-test`.

* Docker 18.09.0+

## Work Branches

* `compiler` - The SchemaType reference compiler
* `docker` - Support for testing in clean Docker environment
* `grammar` - Parser grammar for the `stp` language
* `node_modules` - NodeJS dependencies
* `note` - Notes about the SchemaType project
* `perl5` - Perl5 dependencies
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
