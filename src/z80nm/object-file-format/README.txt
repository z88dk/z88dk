This directory keeps the history of the z80asm object file formats. 
It is intended for preservation only, and documents all versions
up to v19. v18 is the current z80asm format, and v19 is the new
format for the next release of the assembler.

Version	Description
01		original z80asm version
02		allow expressions to use standard C operators instead of the original
		(legacy) z80asm specific syntax
03		include the address of the start of the assembly instruction in the
		object file, so that expressions with ASMPC are correctly computed
		at link time
		remove type 'X' symbols (global library), no longer used
04		include the source file location of expressions in order to give
		meaningful link-time error messages
05		include source code sections
06		incomplete implementation, fixed in version 07
07		include DEFC symbols that are defined as an expression using other
		symbols and are computed at link time, after all addresses are
		allocated
08		include a user defined ORG address per section
09		include the file and line number where each symbol was defined
10		allow a section alignment to be defined
11		allow big-endian 16-bit expressions to be patched; these big-endian
		values are used in the ZXN coper unit
12		allow the target expression of relative jumps to be computed 
		in the link phase
13		add 8-bit signed and unsigned values extended to 16-bits
14		add 24-bit pointers
15		add byte offset to 0xFF00 for gbz80
16		convert all string to lstring in the object file to allow for 
		very large symbol names, needed for C debugging symbols
17		add size of opcode so that DJNZ emulation on Intel and ALD DJNZ 
		on Rabbit compute the right offset
18		add CPU and -IXIY option to disallow linking of objects built for
		a different architecture
		add a string table to remove duplicate strings and speed up linking
19		(not yet in production) 
		add symbol index in the library to speed up linking - only the modules
		that will be needed are parsed
		add end marker in the library instead of -1 file pointer in the last
		module (easier parsing).
