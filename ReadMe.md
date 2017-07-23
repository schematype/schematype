The Official SchemaType Core Types Repository
=============================================

SchemaType definition documents import base types from hosted schematype
repositories and then use those types and/or extend them.

This is the repository of reusable types as defined by SchemaType. The
repository is hosted at:
https://github.com/schematype/schematype/tree/schematype. You can use it in
your `.schema` files like this:
```yaml
-from:
  +core: github:schematype/schematype#schematype

name: +core/str
age: +core/int 1..99
```

or more commonly:
```yaml
-from: github:schematype

name: +str
age: +int 1..99
```

This repo is intended to have 1000s of useful types for you to use, but you do
not need to use these types to use SchemaType. You can write your own hosted
`.stp` files in the same fashion and use those. You can use a combination of
these types and your own. You can fork this repository and host it yourself.
You are encouraged to add useful types to this repository by forking it on
GitHub and then submitting Pull Requests.

The `-from` URLs to this repo use the GitHub scheme. Other schemes will be
supported including `http`. The URLs are always pinned to a specific commit.
The intent is that when the SchemaType compiler compiles a schema, all the
chained references are immutable.

## See Also

* [The SchemaType Web Site](http://www.schematype.org/)
