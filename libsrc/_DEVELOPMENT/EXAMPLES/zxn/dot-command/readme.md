# ZX NEXT ESXDOS DOT COMMANDS

Dot commands are a fantastic way to add command line functionality to basic.  A dot command is loaded into an 8k ram page located at address 0x2000 (it overlaps the rom) and can run without disturbing the basic system.  They are launched from basic by typing their names with a leading dot (hence "dot commands").  Any string following the dot command's name is passed along as a command line.  On return the dot command can generate errors in the basic system, either canned ones or custom ones.

z88dk can automatically generate dot commands from standard C or asm programs.  The only caveat is that their size is limited to about 7k, with the exact amount varying between esxdos versions.

To help mitigate this, z88dk has invented a second type of dot command known as the extended dot command.  Extended dot commands split programs into two parts.  The main part is loaded into the traditional 7k space but the second part is loaded into main memory above ramtop.  The loading of the two parts is taken care of automatically, as is the generation of the two parts from the compile line.  Everything is taken care of by the tools; the result will be two dot command binaries instead of one, both of which must be copied together to the sd card.

For the zx-next specifically, NextOS will be maintaing a service to allocate available 8k memory pages.  z88dk will be targetting this for dot commands, among other compile types, so a third dot command type will be available in the future that allows use of extra memory without taking it away from basic.

## Dot Command Description

### .DZX7

A decompressor for ZX7-compressed files.

### .EXTRACT

A utility that can extract all or a portion of a file and either save to another file or load into the zx-next's memory.

### .STRINGS

A utility for finding text in files.

### TODO LIST

.zx7, .inject, .run, .md5sum, .tsr, .ftp, .dc, .viewnxi, .bmp2nxi, .nxigrab, .zxnreset, .gunzip
