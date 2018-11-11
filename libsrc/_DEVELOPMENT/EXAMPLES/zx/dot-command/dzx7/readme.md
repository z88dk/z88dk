# .DZX7 dot command

To use, copy "DZX7" to the sd card's BIN directory.

`ZX7` is an optimal lz77 compressor written by Einar Saukas with a decompressor counterpart in z88dk's z80 library.  It is frequently used to compress data for z80 machines.  The decompressor has an excellent balance of compression ratio, decompression speed and decompressor size (~70 bytes).

`.dzx7` is the decompressor counterpart for `ZX7`.  The difference between this dot command and the z80 library's decompressor is that this dot command can decompress files of any size, including many megabytes.  The intention is to use `zx7` to transmit compressed files over the internet and then to decompress them on the zx-next itself.

`DZX7` is part of Einar's toolset for the PC and is written in C.  The program has been adapted to z88dk so that it can be compiled for the zx-next and esxdos.  The original source code along with comments by Einar can be found in the [z88dk source repository](https://github.com/z88dk/z88dk/tree/master/src/zx7).

Both `zx7` and `dzx7` are included in z88dk installs.  You can use them to compress and decompress files on your PC for use with z80 code.


## Compiling

`zsdcc` compile (optimization is high so compile time will be long).
~~~
zcc +zxn -vn -subtype=dot -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size dzx7.c ram.asm -o dzx7 -create-app
~~~
`sccz80` compile
~~~
zcc +zxn -vn -subtype=dot -startup=30 -clib=new dzx7.c ram.asm -o dzx7 -create-app
~~~


## Usage

`.dzx7` entered on its own at the basic prompt will print help.

The help text is reproduced here:

~~~
.dzx7 [-f] inname.zx7 [outname]
-f Overwrite output file
~~~

If the output filename is omitted, it will be inferred from the input filename.  `-f` allows overwriting of an existing filename by the output.

While the decompression is underway a `.` will be printed for each 16k written to disk to show progress.  The program can be interrupted at any time by pressing break (caps shift + space).

Most esxdos commands are limited to about 7k in size.  That is true for this program as well, with the code portion confined to 7k, but the decompression requires a 32k buffer space.  That 32k is taken from main memory.  The program does a check to ensure that ramtop is low enough for these buffers and, if not, it will return with an error "M RAMTOP no good (xxxxx)" where the "xxxxx" is the required ramtop value to run.  If this error comes up, the user is expected to "CLEAR xxxx-1" to move basic away from the needed buffer area and then to re-run the dot command.

NextOS will be providing a memory allocator for available 8k pages.  This means dot commands will be able to request memory that is unused without having to take it away from basic.  This program will be modified at a later date to do this so that there will be no ramtop check necessary in the future.
