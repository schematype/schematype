SchemaType
==========

SchemaType is a Data Type Definition Language

# SchemaType Resources

* [SchemaType Website](http://schematype.org)
* [SchemaType Wiki](https://github.com/schematype/schematype/wiki)

# Repository Layout

This repository has lots of independent parts each on their own branch.

The `master` branch only has a `ReadMe` and a `Makefile`.

## Work Branches

* `compiler` - The SchemaType reference compiler
* `docker` - Support for testing in clean Docker environment
* `grammar` - Parser grammar for the `stp` language
* `node_modules` - NodeJS dependencies
* `perl5` - Perl5 dependencies
* `test.compiler` - Compiler test suite

## Makefile Rules

* `make work` - Checkout all branches above into directories
* `make status` - Show git status of all the work branch dirs
* `make realclean` - Remove all the work branches
* `make test` - Run test suite
* `make test-compiler` - Run the compiler test suite
* `make docker-test` - Run the test suite in a Docker container
* `make docker-shell` - Start a shell in the SchemaType Docker container
