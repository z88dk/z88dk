# ESXDOS

This is a collection of examples using esxdos to carry out various filesystem functions.

NextOS expands the original ESXDOS api by adding lfn support and various new functions
exposed from NextOS itself.  In z88dk, the ESXDOS api is kept separate by namespacing
functions with a leading `esxdos_*` and the NextOS ESXDOS api is namespaced with a
leading `esx_*`.  This does mean that many functions exist in both forms and these
functions (will eventually) point to the same code.  The separation is made to make it
clear what is and is not available in original ESXDOS since both DOSes exist on the
ZX Next.

The examples here are intended for the NextOS esxdos api as some of the lfn functionality
and some of the extra NextOS-specific functions may be used.

## DIR - Reading the Contents of Directories

This example shows how to read the contents of a directory and gather information about
files.  The same code could be run on original ESXDOS if the call to `esx_f_opendir_ex()`
is replaced with a call to `esx_f_opendir()` where lfn support is not indicated.  If
maintaining compatibility with original ESXDOS is important, the `esxdos_*` versions of
functions should be used instead of `esx_*` to indicate this.

zsdcc compile:
```
zcc +zxn -v -clib=sdcc_iy -SO3 --max-allocs-per-node200000 dir.c -o dir -subtype=nex -Cz"--clean" -create-app
```

sccz80 compile:
```
zcc +zxn -v -clib=new dir.c -o dir -subtype=nex -Cz"--clean" -create-app
```
