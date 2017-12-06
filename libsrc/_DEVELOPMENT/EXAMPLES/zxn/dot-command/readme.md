# ZX NEXT ESXDOS DOT COMMANDS

Dot commands are an easy way to add command line functionality to basic.  A dot command is loaded into an 8k ram page located at address 0x2000, overlapping the rom, and can run without disturbing the basic system.  They are launched from basic by typing their names with a leading dot, hence the name "dot command".  Any string following the dot command's name is passed as a command line.  On return the dot command can generate esxdos errors in the basic system, either canned ones or custom ones.

Z88DK can automatically generate dot commands from standard C or asm programs.  The only caveat is that their size is limited to about 7k, with the exact amount varying between esxdos versions.  Under NextOS they can occupy the full 8k.

Z88DK invented a second type of dot command known as the extended dot command to get passed the 7k limit.  Extended dot commands ("dotx") split programs into two parts.  The main part is loaded into the traditional 7k space but the second part is loaded into main memory above ramtop.  The loading of the two parts and a ramtop check is taken care of automatically, as is the generation of the two parts from the compile line.  The result of a compile will be two dot command binaries instead of one, both of which must be copied together to the sd card.

For the zx-next specifically, NextOS maintains a page allocator for available 8k memory pages.  A third type of dot command known as "dotn" has been invented to make use of this service.  It is similar to dotx except the second part of the program is loaded into allocated memory pages so that no basic ram is taken and the program can always run without interfering with basic.  The loading of the two parts is taken care of automatically, as is the page allocation and deallocation on exit.  You can also ask for extra pages at compile time if your program will be doing additional banking.  The extra pages will also be automatically allocated and deallocated on exit with the the allocated page numbers made available in an array accessible to your program.  This type of dot command allows the generation of very large programs launched from basic.

(DOTN commands can be generated now but it is still being debugged).

## Technical Notes for Dot Commands

While dot commands run, an 8k divmmc memory page is overlayed on top of the rom in the 0x2000 - 0x3fff address range.  In the bottom 8k, either the esxdos rom or NextOS's compatible rom is present.  The esxdos api is called via `rst $08` (`rst __ESXDOS_SYSCALL`) with a service number following in a `defb`.  Registers contain any parameters expected by the service.

The esxdos api has many functions demanding a parameter in the IX register.  Those parameters should only be in the IX registers when esxdos is not paged in; when the 48k spectrum rom is present the `rst $08` (`rst __ESXDOS_SYSCALL`) will cause the divmmc memory containing esxdos to page in and code is executed that uses HL and then loads IX into HL before carrying out the call.  However, when esxdos is already present, as is the case for a running dot command, this does not happen and the parameter is expected to be in HL already.  The Z88DK library functions that call into esxdos put those parameters into both HL and IX so that programs can use the esxdos api without having to worry about whether they are a dot command or not.  However if you are examining the crts that Z88DK uses to start dot commands, you will probably see those parameters loaded into HL only.

Since esxdos occupies the bottom 8k and the dot command itself occupies a divmmc page in the next 8k, rom routines are not directly accesible.  For Z88DK programs this is not really a problem because the entire library is independent of the rom, except for one exception - the optional crts that use basic's `rst $10` to print to screen.  These crts are especially attractive for traditional dot commands (those limited to 7k) because using the rom routines for printing shrinks program size.  Fortunately has a method for calling into the 48k rom via `rst $18` (`rst __ESXDOS_ROMCALL`) with the rom address in a following `defw`.  When calling into the rom, any data in divmmc memory will not be visible because the 48k rom will be paged in while the rom call executes.  Further, the system variables in mmu2 (16k to 24k area) must be visible, which would normally be the case unless the dot command does some paging there.  `rst $10` is also implemented as a special case of `rst $18` so that dot commands can print as if the rom were present.

Under NextOS there is also a distinction between DOTN and DOTX/DOT.  In 48k mode, NextOS is not available which means DOTN commands cannot be run.  DOTN commands started in 48k mode will automatically exit with an error message saying as much.  To allow the same dot command to run in either 48k or 128k NextOS mode, Z88DK will be providing a selector program that will automatically select a DOTX or DOTN version of the dot command depending on whether the machine is in 48k mode or not.  For most dot commands this will mean you can build something that will work in all mode yet still take advantage of NextOS in DOTN commands when possible.


## Dot Command Description

### .DZX7

A decompressor for ZX7-compressed files.

### .EXTRACT

A utility that can extract all or a portion of a file and either save to another file or load into the zx-next's memory.

### .STRINGS

A utility for finding text in files.

### TODO LIST

.zx7, .inject, .run, .md5sum, .tsr, .ftp, .viewnxi, .bmp2nxi, .nxigrab, .zxnreset, .gunzip, .tar
