# .STRINGS dot command

To use, copy "STRINGS" to the sd card's DOT directory.

## Compiling

```
zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o strings -pragma-include:zpragma.inc -subtype=dot-n -Cz"--clean" -create-app
```

## Usage

`.strings` entered on its own at the basic prompt will print help.

This utility searches for ascii text strings stored in files.  Results can be printed to screen or saved to an output file.

The help text is reproduced here:

~~~
.strings file [-n num]
 [-s string] [-t {o,d,x}]
 [-w] [-f] [-o file] [-a file]

 -n = set min string len (4)
 -s = print separator ("\n")
 -t = file offset dec/oct/hex
 -w = make \r\n part of string

 -f = overwrite permitted
 -o = output filename
 -a = append filename

no -o,-a prints to screen

strings v1.2 zx-next z88dk.org
~~~

## Examples

1. Look for strings at least 6 chars long.  If found print the file offset in hex along with the string.  Output to screen.

```
.strings knight.sna -n 6 -t X
```

2.  Look for strings and save findings to an output file.  Print file offset in decimal and print a separator between findings.

```
.strings knight.sna -t d -s ------- -o string.txt
```
