# FAR MEMORY SUPPORT FOR MSX
This is a toy implementation of far memory [specifications](https://github.com/z88dk/z88dk/wiki/More-Than-64k) for MSXDOS2 memory mapper. It's slow and partial, but it's a starting point.
The malloc just increment a global pointer (one per segment). Free is just a stub and realloc is not implemented yet.

The files included are:
* `msxmapper.c`: code to interact with the MSXDOS2 memory mapper
* `memoryman.c`: C implementation of the specifications
* `mallocfar.s`: asm code interfaces

The functions implemented are:

* `malloc_far`
* `free_far` (just a stub)
* `lp_gchar`, `lp_pchar`
* `lp_gint`, `lp_pint`
* `lp_gptr`, `lp_pptr`

What's missing:

* read/write code for long and double (easy to implement starting from the functions above)
* string related functions, such as strlen_far, strcat_far, etc

## Test it

`$ make`

This generates the file `memoryman.com`. It prints allocation, read, write benchmarks.

![FAR MALLOC BENCHMARKS](screenshot.png?raw=true "FAR MALLOC BENCHMARKS")
