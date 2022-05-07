The new c library contains a [more recent version of sp1](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/EXAMPLES/zx/demo_sp1) that is compatible with zsdcc.  sp1 is being updated again and that version will be included in the classic library.

In order to compile the examples, "sp1.lib" must be copied to z88dk/lib/clibs and "ts2068hr-sp1.h" must be copied to z88dk/include/sprites and renamed to "sp1.h".

The examples are inlining asm at global scope in a .c source file to declare graphics.  This should no longer be done as it is incompatible with z88dk's section model and it is not compilable with zsdcc as compiler.  Instead such asm should be placed in its own separate .asm file that is added to the compile line.  For this reason these examples can only be compiled using the classic library and sccz80 as compiler.  Once the new version of sp1 is complete the examples will be updated to get rid of the bad practice.
