# .EXTRACT dot command

To use, copy "EXTRACT" to the sd card's DOT directory.

## Compiling

~~~
zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o extract -pragma-include:zpragma.inc -subtype=dot -Cz"--clean" -create-app
~~~

## Usage

`.extract` entered on its own at the basic prompt will print help.

This utility reads some portion of a file and either:

* saves that portion to another file
* appends that portion to another file
* loads that portion into the zx-next's memory
* prints that portion in a hexdump

The data can be loaded anywhere in the zx-next's memory space.  The destination address can be specified as a 64k address within the current banking arrangement, as a linear address covering the entire zx-next memory space in [0x000000,0x1BFFFF], as a 16k bank number in [0,111], or as an 8k page number in [0,223].

All numbers can be specified in decimal, hexadecimal (leading 0x) or octal (leading 0).

The help text is reproduced here:

~~~
.extract file [+off][-off][len]
 [-f] [-o file] [-a file]
 [-m addr] [-ml linaddr]
 [-mp pnum] [-mb bnum]

input:
  file = input file
  +off = byte offset from start
  -off = byte offset from end
   len = length in bytes

output:
  -f  = overwrite permitted
  -o  = write to out file
  -a  = append to out file
  -m  = copy to 64k addr
  -ml = copy to linear addr
  -mp = copy to start of page
  -mb = copy to start of bank

no -o,-a,-m* generates hexdump

extract v1.3 zx-next z88dk
~~~

## Examples

1. Display the screen stored in an sna snapshot file:

`.extract knight.sna +27 6912 -m 0x4000`

Extract 6912 bytes from file "knight.sna" at offset 27 and write to 64k memory address 0x4000.

2. Have a look at the sna header as a hexdump:

`.extract knight.sna 27`

Extract the first 27 bytes from file "knight.sna" and view it as a hexdump printed to screen.

3. Copy the last 1024 bytes of a file to another file:

`.extract knight.sna -1024 -o knight.bin`

Extract the last 1024 bytes from file "knight.sna" and save it to file "knight.bin".  If "knight.bin" already exists, an error will be produced (see -f).

4. Append file to another one.

`.extract knight.sna -a foo.bin`

Extract the entire file "knight.sna" and append it to the file "foo.bin".

5. Load file to page 18
~~~
.extract knight.sna -mp 18
.extract knight.sna -mb 9
.extract knight.sna -ml 0x24000
~~~

Load the entire file "knight.sna" to the zx next's memory.  All variations above load the file contents to the same place in memory.  The first command indicates the location using 8k page number.  The second command indicates the location using 16k bank number.  The last command indicates the location using a linearized memory address.
