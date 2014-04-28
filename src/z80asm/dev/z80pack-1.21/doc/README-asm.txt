Usage:

z80asm -ofile -f[b|m|h] -l[file] -s[n|a] -x -v -dsymbol ... file ...

A maximum of 512 source files is allowed. If the filename of a source
doesn't have an extension the default extension ".asm" will be
concatenated. Source file names may have a path, the maximum length of
a full qualified filename is 2048 characters.
For relative paths the extension must be used, because all characters
after a "." would be used as extension!

Option o:
To override the default name of the output file. Without this option
the name of the output file becomes the name of the input file,
but with the extension ".bin" or ".hex". The output file may have a path,
the maximum length is limited to 2048 characters.

Option f:
Format of the output file:

	-fb -> binary file
	-fm -> binary file with Mostek header
	-fh -> Intel hex

Option l:
Without this option no list file will be generated. With -l a list
file with the name of the source file but extension ".lis" will be
generated. An optional file name with path (2048 characters maximum)
may be added to this option.

Option s:
This option writes the unsorted symbol table (-s), sorted by name (-sn)
or sorted by address (-sa) into the list file. This option only works
together with option -l.

Option x:
Don't output data in pass 2 into object file for DEFS. This only works
if unallocated data isn't followed by any code or initialised data!
Useful for CP/M BIOS's, where unallocated data doesn't need to be
part of the system image, if the complete image won't fit on the system
tracks.

Option v:
Verbose operation of the assembler.

Option d:
This option predefines symbols with a value of 0.
The number of this option is not limited in the command line.

Pseudo Operations:

Definition of symbols and allocation of memory:

	 ORG    <expression>    - set program address
<symbol> EQU    <expression>    - define constant symbol
<symbol> DEFL   <expression>    - define variable symbol
<symbol> DEFB   <exp,'char',..> - write bytes in memory
<symbol> DEFW   <exp,exp..>     - write words (16 bits) in memory
<symbol> DEFM   <'string'>      - write character string in memory
<symbol> DEFS   <expression>    - reserve space in memory


Conditional assembly:

IFDEF   <symbol>        - assemble if symbol defined
IFNDEF  <symbol>        - assemble if symbol not defined
IFEQ    <exp1,exp2>     - assemble if equal
IFNEQ   <exp1,exp2>     - assemble if not equal
ELSE                    - else for all conditionals
ENDIF                   - end of conditional assembly


Manipulation of list file:

PAGE    <expression>    - number of lines/page
EJECT                   - skip to new page
LIST                    - listing on
NOLIST                  - listing off
TITLE   <'string'>      - define title for page header


Others:

INCLUDE <filename>      - include another source file
PRINT   <'string'>      - print string to stdout in pass one
