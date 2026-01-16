# ZX SPECTRUM FZX PROPORTIONAL FONTS

[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/font/fzx)  
[Plain Z88DK Header](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/font/fzx.h)

Read about the "fzx_modes" example before this one for background information.

This example renders text using a tiny font in two columns on screen.  The text has purposely been rendered such that the colouring of the columns is only affected by the fzx text rendering in order to show where the fzx rendering is actually changing the colours on screen.  It would otherwise be preferential to pre-colour the two columns so that they were a solid colour.

A couple of new functions from the library are used to display justified text.  One function, `fzx_buffer_partition()`, finds the longest string of text that will fit into a horizontal pixel space without breaking words.  Another, `fzx_write_justified()`, will write that text into a fixed pixel width horizontal window, expanding spaces between words to right justify the text.  There are more primitive functions that merely measure pixel width of strings or buffers but these functions are ideal for rendering justified text.

The text comes from the freely available book "The Jungle" by Upton Sinclair.

## Compiling the Example

sccz80 compile:
```
zcc +zx -vn -startup=31 -O3 -clib=new fzx_reader.c The_Jungle.c -o fzxr -create-app
```
zsdcc compile:
```
zcc +zx -vn -startup=31 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 fzx_reader.c The_Jungle.c -o fzxr -create-app
```
