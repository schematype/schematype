This branch contains the code for the `schematype-linker` tool.

This tool is called by `stp --compile ...` and `stp --link ...` to finalize the
compilation of an stp file. It fetches the Import references, and links their
info into the final `.stx` file format.
