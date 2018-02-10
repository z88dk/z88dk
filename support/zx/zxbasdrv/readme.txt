ZX BASIC driver specifications
by Stefano Bodrato, July 2006.

$Id: readme.txt,v 1.3 2007-07-03 07:32:03 stefano Exp $


The "zxbasdrv" driver is a trick to get some basic functionality
from the fcntl functions on a ZX Spectrum and to have a sort of
simple hardware abstraction layer for similar needs (hardcopy, etc).

See the samples in this directory:
you can write your own driver directly in BASIC; if your hardware doesn't
support strams, you'll be able only to implement simple non-standard
block LOAD and SAVE functions, unless you'll decide to write your
own implementation for that  :oP

The ASM part extracts a drive path from the file names, so you can 
specify them with an MS-DOS like syntax.
Valid examples for file names are:
	"a:filename"	(drive #1)
	"H:filename"	.. i.e. 8th microdrive
	"filename"	(the file will be searched in drive #1)
	"2:filename"	..numbers are allowed, too !
	"P::"		Printer device on stream #3

-----------------------------------------------------------------------
Description of the line numbers corresponding to the various functions:
-----------------------------------------------------------------------


10 - (just after the LOAD CODE command), set d=<default drive number>


7499 - query driver description
s$ = Name/Description


7500 - OPEN sequential file
s=stream number (4-15); the ASM part detects the existence of the channel
			and handles a "file not found" condition if it is missing
f=mode flag (0=read, 256=write, etc..)
d=drive number (it is extracted from the file name, see above)
n$=file name


7550 - CLOSE sequential file
s=stream number


7600 - LOAD block
a=address or 0 if unspecified
l=length or 0 if unspecified
d=drive number
n$=file name


7650 - SAVE block
a=addess
l=length
d=drive number
n$=file name


7700 - Init printer channel (open #3)
Optionally you can handle a "file name" to redirect the printer output.
This entry works as a sort of "OPEN" command, but the stream number 
must be forced to #3.


7750 - Close printer channel (close #3)


7800 - Do hardcopy (or dump screen to file, or whatever you prefer)


7900 - DELETE file
d=drive number
n$=file name


7950 - RENAME file
d=drive number
n$=old file name
o$=new file name

