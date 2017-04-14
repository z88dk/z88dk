Z88DK Z80 Module Assembler Change Log
=====================================

2017
----

- 2016-01-30 Fix #49 implement z180 as a target
- 2017-01-26 Fix #47 accept more that one MODULE directive
- 2017-02-08 Fix #53 public constants not being listed in global .def file
- 2017-02-09 Fix #54 overflow errors in calculated constants at linking stage
- 2017-02-12 Fix #65 separate BSS section not generated from object file if BSS org was -1 at assembly time
- 2017-04-12 Fix #159 allow environment variables ${VAR} in the command line options and arguments and list files (contribution from dom@suborbital.org.uk)

2016
----

- 2017-01-01

  Summary of 2016 changes:

[z80asm] Handle input files more predictably: link .o files; assemble any other extension; append a .asm or .o option to the file name to allow just the basename
[z80asm] Make a consolidated object file with -o and not -b: all the object modules are merged, the module local symbols are renamed <module>_<symbol>
[z80asm] Link the library modules in the command line sequence (it was depth-first)
[z80asm] Add directory of assembled file to the end the include path to allow includes relative to source location
[z80asm] Remove all generated files at start fo assembly to remove files from previous runs
[z80asm] Remove deprecated directives: XREF and LIB (replaced by EXTERN), XDEF and XLIB (replaced by PUBLIC), OZ (keep CALL_OZ)
[z80asm] Rename DEFL to DEFQ to reserve DEFL for macro variables; rename DS.L by DS.Q
[z80asm] Constants for section sizes: prune empty sections, rename ASMHEAD, ASMTAIL and ASMSIZE to __head, __tail and __size respectively, rename ASM<HEAD|TAIL|SIZE>_<section_name> to __<section_name>_<head|tail|size> 
[z80asm] Environment variables no longer used: Z80_OZFILES, Z80_STDLIB
[z80asm] Command line option -r, --origin: accept origin in decimal or hexadecimal with '0x' or '$' prefix
[z80asm] Command line options: -i, -x: require a library name
[z80asm] Command line options: remove -RCMX000, keep only --RCMX000
[z80asm] Command line options: remove -plus, keep only --ti83plus
[z80asm] Command line options: remove -IXIY and --swap-ix-iy, keep --IXIY
[z80asm] Command line options: remove --sdcc, -nm, --no-map, -ng, --no-globaldef, -ns, --no-symtable, -nv, --no-verbose, -nl, --no-list, -nb, --no-make-bin, -nd, --no-date-stamp, -a, --make-updated-bin, -e, --asm-ext, -M, --obj-ext, -t
[z80asm] Make symbol files, map files and reloc files optional; do not merge symbols in the list file; do not paginate and cross-reference symbols in list file; rename list file to file.lis (@file.lst is used as project list)
[z80asm] Unify format used in map files, symbol files and global define files, output list of symbols only once
[z80asm] Include symbols computed at link time in the global define file
[z80asm] Simplify output of --verbose

- 2016-10-16

  Add consolidated object file.
  When -o objectfile is given without -b, all the object modules from the command line 
  are merged into one consolidated object file. The module local symbols are renamed 
  <module>_<symbol> to avoid clashes in the merged symbol table.

- 2016-10-10

  Rename generated constants to start with '__', prune empty sections
  Rename ASMHEAD, ASMTAIL and ASMSIZE to __head, __tail and __size respectively.
  Rename ASM<HEAD|TAIL|SIZE>_<section_name> to __<section_name>_<head|tail|size>. 
  
- 2016-09-17

  Remove -M, --obj-ext option. The object file has always the .o extension.
  
- 2016-09-16

  Remove -e, --asm-ext option. The asm file can have any extension. If the input
  file does not exist, ".asm" is appended and checked again.
  
- 2016-09-04

  Change handling of input files to make it more predictable:
  - if a .o file is given, and it exists, it is used without trying to assemble first
  - if the given file exists, whatever the extension, try to assembly it, 
    i.e. there is no more the need to pass -eopt to assemble .opt files.
  - if all above fail, try to replace/append the .asm extension and assemble
  - if all above fail, try to replace/append the .o extension and link
    
- 2016-07-29

  Remove OZ directive - it is an alias to CALL_OZ, and apparently not used
  in the library. 
  CALL_OZ is a macro for "RST 20h; DEFB xx" if xx < 100h, and "RST 20h, DEFW xx"
  otherwise.

- 2016-07-15

  Replace DEFL by DEFQ (quad-byte) to leave DEFL free for the standard 
  way to define text values in macros.
  Replace DEFGROUP DS.L by DS.Q for consistency.

- 2016-07-14

  Remove deprecated instructions:
  - Remove XREF and LIB, use EXTERN instead
  - Remove XDEF and XLIB, use PUBLIC instead

  Change options so that long options are always prefixed by two dashes,
  modify calling code to use the two-dash form.
  - Remove -RCMX000, keep only --RCMX000
  - Remove -plus, keep only--ti83plus
  - Remove -IXIY and --swap-ix-iy, keep --IXIY

- 2016-07-11

  Log Message:
  Revert some of the oversimplification of verbose output:
  - put back file being assembled and files being read
  - put back library being created
  - put back module being linked from library

- 2016-07-09

  Remove reference to the Z80_STDLIB environment variable - it was used
  as a default library for the -i and -x options - and force the options
  to have a library file argument.

- 2016-07-08

  Add the directory of each assembly file being assembled to the end 
  of the include path, and remove at the end of the assembly. This allows
  the assembly file to include files relative to its location.

- 2016-07-06

  Remove reference to the Z80_OZFILES environment variable - it was used
  as an additional directory to search for include files.

- 2016-07-03

  Only generate .reloc file if --reloc-info option is given.
  The .reloc file contains the list of all relocatable addresses in the 
  binary file and is only required in some platforms.
  
  Change -r and --origin to accept the origin address in decimal instead
  of hexadecimal by default. Accept hexadecimal with a '0x' or '$' prefix,
  or with a 'h' suffix.  

  Change extension of list files to .lis instead of .lst, as .lst is 
  usualy used in @project.lst files as input to z80asm.

- 2016-06-30

  Unify map-, def- and sym-files - they differ only in the filter used
  to select the labels to write, but use the same format and the same 
  output function.
  
  Remove -nv and --no-verbose options.

  Remove -nb and --no-make-bin options.
  
  Remove -nd and --no-date-stamp options. 
  
  Remove -a and --make-updated-bin options - they are aliases to -b -d.

  Remove -nl and --no-list options. 
  
  Simplify output of -v and --verbose.
  
- 2016-06-28

  Only generate .sym file if -s or --symtable option is given.
  Sym file contains only one list of symbols, ordered by value, and in 
  '$'-hex notation, e.g. $1234.

  Remove -ns and --no-symtable options.
  
  Remove all generated files at start of assembly to assure that old 
  files of old compilations were not left arround.

- 2016-06-27

  Only generate .map file if -m or --map option is given.
  Map file contains only one list of symbols, ordered by value, and in 
  '$'-hex notation, e.g. $1234.
  
  Remove options -nm and --no-map.

  Remove deprecated option -t - was used to replace spaces by tabs in the
  map file.

  Change def-file to contain also symbols computed at link time, 
  instead of only the address-type ones, so that DEFC alias to global 
  symbols are written out.

  Remove -ng and --no-globaldef options.

- 2016-06-26

  Do not create paginated list and symbol files with headers, page numbers
  and form-feeds; keep just a list of output text.
  
  Do not create symbol cross-reference list - it contained page number
  references in the list file.

- 2016-06-25

  Create symbol list always in file.sym; when a file.lst was requested
  the symbol list was appended to the file.lst. This was causing problems
  to appmake.

- v **2.8.5**, 2016-03-07, pauloscustodio

  --sdcc option (SDCC hack) removed. It was used to search library symbols
  with an underscore prefix after a lookup failure.

- v **2.8.4**, 2016-02-24, pauloscustodio

  BUG_0038: library modules not loaded in sequence  
  The library modules are now loaded in the sequence given on the command line.  
```
    "z80asm -ilib1 -ilib2 obj1.o obj2.o"
```
  now loads obj1, obj2, objects from lib1, objects from lib2 in this
  order.


2015
----

- v **2.8.3**, 2015-11-23, pauloscustodio
	When several sections are packed into one binary file, pack the 
	corresponding reloc files.

- v **2.8.2**, 2015-11-17, pauloscustodio
	Create relocation file for each section

	Create a file.reloc file for each file.bin section binary with a list 
	of 16-bit addresses of locations in the file.bin that need to be relocated.

	When --relocatable is used, create single-section binaries and 
	ignore ORG statements.

- v **2.8.1**, 2015-09-18, pauloscustodio  
	Maintenance release for C version. C++ version under development in 
	<https://github.com/pauloscustodio/z80asm>

- 2015-08-04, pauloscustodio  
	Use Template::Toolkit to generate files from templates - tokens.h

	Create tt/tokens.yaml with the input data for the tt/tokens.h.tt template.
	These are used by the Makefile to produce tokens.h.

	Remove old tokens.def and tokens.h.in with filepp.pl macro magic.

	Remove filepp.pl call from dev/Makefile and filepp.html documentation.

- v **2.8.0**, 2015-08-02, pauloscustodio  
	- Make assembler case sensitive to be more C-code friendly.

- v **2.7.1**, 2015-08-02, pauloscustodio
	- Symbol can be declared both EXTERN and PUBLIC in the same file
	
	- z80asm was evaluating the false branches of IF..ENDIF again;
	  fixed and modified opcodes.t to detect this.

	- Removed fatal errors and TRY-CATCH - code with longjumps is harder to maintain.
	  Removed except.c.

	- Removed legacy expression syntax support and got rid
	  of all the #ifdef __LEGACY_Z80ASM_SYNTAX.

	- Added support for binary constants %0101 syntax.

	- Added debug macros and unit test module. Replaced xmalloc.c by alloc.c,
	  which has the possibility of registering a destructor function for
	  each allocated memory block, to be called on free() of the memory block.
	
	- Added GLOBAL declaration: define a symbol EXTERN if not defined locally,
	  or PUBLIC if defined locally.

	- Assume an at least 32-bit machine and use always int for integer types.

	- Use new str.c library that allows the creation of expandable string buffers
	  as automatic variables in the stack - if the string grows beyond the
	  initial buffer size, a new buffer is allocated in the heap and 
	  automatically freed atexit.
	
	- Removed option -forcexlib - no longer necessary, as the module name is no 
	  longer used as the symbol to force the link of a library module.

	- Show symbol name "symbol not defined" in error message.
	
	- Accept a GLOBAL declaration for a symbol already declared as PUBLIC or EXTERN.
	  Accept a PUBLIC declaration for a symbol already declared as GLOBAL or EXTERN.
	  Accept an EXTERN declaration for a symbol already declared as GLOBAL or PUBLIC.

- 2015-02-09, pauloscustodio  
	Rename init() macro to init_module()

- 2015-02-08, pauloscustodio  
	Add debug macros and mini-unit test module

- 2015-02-08, pauloscustodio  
	Rename xfopen and xfclose

- 2015-02-01, pauloscustodio  
	Removed legacy expression syntax support and got rid
	of all the #ifdef __LEGACY_Z80ASM_SYNTAX.

	Added support for binary constants %0101 syntax.

- v **2.7.0**, 2015-01-26, pauloscustodio
	- Add lexer tokens for registers, CPU flags, DEFVARS size specifiers,
	  opcodes and directives, simplifying the parser. Build in a tokenizer 
	  state to allow an opcode name (e.g. RL) to be used as a label, a 
	  defc, defgroup or defvars constant.
	  
	- Implemented parsing based on a RAGEL state machine, calling the existent
	  recursive-descent parser for expressions.  Made parser re-entrant.
	  
	- New opcodes.c module to store away all the Z80 opcode hex bytes.
	
	- IFDEF / ELSE / ENDIF implemented
	  
	- IFNDEF / ELSE / ENDIF implemented
	
	- New --split-bin option to split binary file per section. 
	
	- New ORG -1 to a section to be written to a new binary file, even if
	  the address is consecutive with the previous section.

- 2015-01-26, pauloscustodio  
	Add list of future features

- 2015-01-26, pauloscustodio  
	Updated copyright year

- 2015-01-26, pauloscustodio  
	Implemented IF, IFDEF, IFNDEF, ELSE, ENDIF within the RAGEL parser.
	Finished replacing the statement parser by a RAGEL state machine, except for
	the expressions' parser, which is still a recursive-descent parser.

- 2015-01-18, pauloscustodio  
	Implemented MODULE within the RAGEL parser

- 2015-01-17, pauloscustodio  
	Implemented INCLUDE within the RAGEL parser. Changed the parser to be reentrant.

- 2015-01-11, pauloscustodio  
	Allow opcodes (e.g. RL) as constants in DEFC, DEFGROUP and DEFVARS, and as labels

2014
----

- 2014-12-24, pauloscustodio  
  Make tokenizer context-sensitive, to be able to distinguish (TK_DI) from (TK_NAME, "di") in:
  di  
  call di

- 2014-12-13, pauloscustodio  
	Implemented infrastructure to do parsing based on a RAGEL state machine,
	and to fall back to the original parser on error. Implemented the first
	two simple opcodes (NOP and HALT) as a concept check.

- 2014-12-04, pauloscustodio  
	No longer needs to backtrack during parsing, remove ScanGetPos() and
	ScanSetPos().

- 2014-12-04, pauloscustodio  
	Add lexer tokens for registers, CPU flags and DEFVARS size specifiers,
	simplifying the parser. As a side effect register names can no longer
	be used as labels, but this would be confusing anyway.

- v **2.6.1**, 2014-10-03, pauloscustodio  
	- Remove option -c (split in 16k blocks) - no longer necessary with
	  split binary files for each section with a defined ORG.
	  
- v **2.6.0**, 2014-09-28, pauloscustodio  
	- Split binary files for each section with a defined ORG
	
	- Object file format changed to version 08, to include ORG address
      per section.
	  
- v **2.5.0**, 2014-09-11, pauloscustodio  
	- DEFC with expressions; expressions containing external symbols are 
	  stored in the object file and evaluated at link time.  
	  e.g.  ```
	  PUBLIC alias  
	  EXTERN func  
	  DEFC alias = func  
	  ```

	- Object file format changed to version 07, to include DEFC symbols that 
	  are defined as an expression using other symbols and are computed at link 
	  time, after all addresses are allocated.
	  
	  DEFC with expressions enabled.
	  
	  1) Symbols are now linked into expressions so that the symbol value 
	     is used during expression eval. Before the symbol value was frozen
		 during expression parse.  
      2) Symbols cannot be deleted and re-created when moving from local to global
	     table, to keep references in expressions pointing to allocated memory.  
	  3) Symbols need to have a new category: computed, actual value not
	     yet known.  
	  4) ASMPC needs to be recomputed at pass2 and link time.

	- Separate expression type from expression range - new range_t enum 
	  type for ranges and new range attribute in Expr.
	  
	- Separate symbol type from the bit mask stored in Symbol and Expr, 
	  to be able to identify constant values, values that need to be 
	  relocated and values that need to be computed at the end of the 
	  link phase (for DEFC with expressions). 
	  
	- Remove SYM_DEFINE, not used.

- v **2.4.1**, 2014-06-26, pauloscustodio  
	- Bugfix in sections: wrong address computation when symbols declared
	  public in a different section that the definition.
	  If a symbol was defined in the "code" section, and then declared public
	  in a "data" section, it was stored in the object file as if it was defined
	  in "data", causing wrong address computations at link time.

	- Write empty sections to the object file, to allow the user to define
	  the sections sequence in the final binary by writing a list of empty 
	  sections at the top of the source file, even if the source does not
	  assembly any data for some of the sections, e.g.:  
```	  
			section code  
			section data  
			section bss  
```

- v **2.4.0**, 2014-06-24, pauloscustodio  
	- Object file format changed to version 05, to include section names for 
	  expressions, names and object code.
	
	- Write expressions to object file only in pass 2, to remove duplicate code
	  and allow simplification of object file writing code. All expression
	  error messages are now output only during pass 2.

	- Write object file in one go at the end of pass 2, instead of writing
	  parts during pass 1 assembly. This allows the object file format to be
	  changed more easily, to allow sections in a near future.
	  Remove global variable objfile and CloseFiles().
	  
	- Do not sort symbols before writing to object file. Not needed and 
	  wastes time.

	- Extended codearea.c to support different sections of code.
	
	- Modified the address computations in pass 2 and during linking and
	  the generation of the binary image to support the sections defined 
	  in the codearea.
	  
	- Added support to sections in the object code area of the object file.
	
	- Written ORG to object file as a 32-bit integer to allow ORG 0xFFFF.

    - SECTION keyword parsed to change to a new section.
	
- v **2.3.0**, 2014-05-29, pauloscustodio  
	- CH_0025: Link-time expression evaluation errors show source filename and line number
		Object file format changed to version 04, to include the source file 
		location of expressions in order to give meaningful link-time error messages.

- v **2.2.1**, 2014-05-25, pauloscustodio  
	- BUG_0049: Making a library with -d and 512 object files fails - Too many open files
		Error caused by z80asm not closing the intermediate object files, when
		assembling with -d.

	- BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
		When a library is built with -d, and the total size of the loaded 
		modules is more than 64K, z80asm fails with "max. code size reached".

	- BUG_0051: DEFC and DEFVARS constants do not appear in map file
		Constants defined with DEFC and DEFVARS, and declared PUBLIC are not
		written to the map file.
		Logic to select symbols for map and def files was wrong.

	- Clean-up test files
	- Parse argv generates list of files that can be iterated by assembler,
	  linker and librarian.
	- Move load_module_object() that loads object file size when assembling
	  with -d option to objfile.c. 
	- Add ASMHEAD symbol at the end of link with address of start of linked code.
	- Link expressions to the section they refer to.

- 2014-05-17, pauloscustodio  
	Use C99 integer types

- 2014-05-06, pauloscustodio  
	Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h

- v **2.2.0**, 2014-04-23, pauloscustodio  
	- Object file format changed to version 03, to include address of start
	  of the opcode of each expression stored in the object file, to allow 
	  ASMPC to refer to the start of the opcode instead of the patch pointer.
	  This solves long standing BUG_0011 and BUG_0048.

	- ASMPC no longer stored in the symbol table and evaluated as a separate 
	  token, to allow expressions including ASMPC to be relocated. This solves
	  long standing and never detected BUG_0047.

	- Handling ASMPC during assembly simplified - no need to call inc_PC() on
	  every assembled instruction, no need to store list of JRPC addresses as
	  ASMPC is now stored in the expression.

	- BUG_0046: Expressions stored in object file with wrong values in MacOS
		Symptom: ZERO+2*[1+2*(1+140709214577656)] stored instead of ZERO+2*[1+2*(1+2)]
		Problem caused by non-portable way of repeating a call to vsnprintf without 
		calling va_start in between. The repeated call is necessary when the 
		dynamically allocated string needs to grow to fit the value to be stored.

	- BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
		ASMPC is computed on zero-base address of the code section and expressions
		including ASMPC are not relocated at link time.
		"call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
		The expression ASMPC+3 is not marked as relocatable, and the resulting
		code only works when linked at address 0.

	- BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
		In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead 
		of instruction-address.

    - BUG_0011: ASMPC should refer to start of statement, not current element in DEFB/DEFW
        - Bug only happens with forward references to relative addresses in
          expressions.
        - See example from zx48.asm ROM image in t/BUG_0011.t test file.
        - Need to change object file format to correct - need patchptr and
          address of instruction start.

	- Change struct expr to Expr class, use CLASS_LIST instead of linked list
	  manipulating.
	- Factor parsing and evaluating constants.
	- Factor symbol-not-defined error during expression evaluation.
	- Store module name in strpool instead of m_strdup/m_free.
	- Fix test scripts to run in UNIX.
	- As inc_PC() is no longer needed, append_opcode() no longer makes sense.
	  Removed append_opcode() and created a new helper append_2bytes().

- 2014-04-19, pauloscustodio  
	BUG_0046: Expressions stored in object file with wrong values in MacOS
	Symthom: ZERO+2*[1+2*(1+140709214577656)] stored instead of ZERO+2*[1+2*(1+2)]
	Problem caused by non-portable way of repeating a call to vsnprintf without
	calling va_start in between. The repeated call is necessary when the
	dynamically allocated string needs to grow to fit the value to be stored.

- 2014-04-18, pauloscustodio  
	- Change struct expr to Expr class, use CLASS_LIST instead of linked list
	  manipulating.
	- Factor parsing and evaluating contants.
	- Factor symbol-not-defined error during expression evaluation.
	- Store module name in strpool instead of m_strdup/m_free.

- v **2.1.8**, 2014-04-13, pauloscustodio  
	- CH_0024: Case-preserving, case-insensitive symbols
		Symbols no longer converted to upper-case, but still case-insensitive 
		searched. Warning when a symbol is used with different case than
		defined. Intermediate stage before making z80asm case-sensitive, to
		be more C-code friendly.
		
	- CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
		Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
		Remove 'X' scope for symbols in object files used before for XLIB -
		all PUBLIC symbols have scope 'G'.
		Remove SDCC hack on object files trating XLIB and XDEF the same.
		Created a warning to say XDEF et.al. are deprecated, but for the 
		moment keep it commented.

	- Merge test files.
	- Remove token.c module - no longer needed with the ragel scanner.

- v **2.1.7**, 2014-04-03, pauloscustodio  
	- CH_0023: Accept C-like escape sequences in character constants and strings
		Accepts \a, \b, \e (0x1B), \f, \n, \r, \t, \v, \{any character} 
		\{octal}, \x{hexadecimal}, allows \0 within the string.
		Existing code may have to be modified, e.g.  
```
			defb '\' 	--> defb '\\'  
```

	- BUG_0045: -D did not accept symbols starting with ' _ '
		(reported and fixed by alvin_albrecht@hotmail.com)
	
- v **2.1.6**, 2014-03-29, pauloscustodio  
	- BUG_0044: binary constants with more than 8 bits not accepted
		Limit of 8 bits removed.
	
	- CH_0022: Added syntax to define binary numbers as bitmaps, e.g.  
```
			defb @"--------"	; 0x00  
			defb @"---##---"	; 0x18  
			defb @"--#--#--"	; 0x24  
			defb @"-#----#-"	; 0x42  
			defb @"-######-"	; 0x7E  
			defb @"-#----#-"	; 0x42  
			defb @"-#----#-"	; 0x42  
			defb @"--------"	; 0x00  
```

	- Replaced tokenizer with Ragel based scanner.  
	  Simplified scanning code by using ragel instead of hand-built scanner 
	  and tokenizer.  
	  Removed 'D' suffix to signal decimal number.  
	  Parse AF' correctly.  
	  Decimal numbers expressed as sequence of digits, e.g. 1234.  
	  Hexadecimal numbers either prefixed with '0x' or '$' or suffixed with 'H', 
	  in which case they need to start with a digit, or start with a zero,
	  e.g. 0xFF, $ff, 0FFh.  
	  Binary numbers either prefixed with '0b' or '@', or suffixed with 'B', 
	  e.g. 0b10101, @10101, 10101b.
	  
	- Accept both ```"ex af,af"``` and ```"ex af,af'"```

- v **2.1.5**, 2014-03-06, pauloscustodio  
	- BUG_0043: buffer overflow on constants longer than 128 chars in object file
		z80asm crashed when the expression to be stored in the object file was
		longer than the maximum allocated size (128). Changed to dynamic string.

- 2014-03-03, pauloscustodio  
Rename symbol type constants

- v **2.1.4**, 2014-03-01, pauloscustodio  
	- CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:  
		Handle C-like operators, make exponentiation (**) right-associative.  
		Simplify expression parser by handling composed tokens in lexer.  
		Change token ids to TK_...  
		The original z80asm scanner used a simple heuristic to convert an 
		identifier to a number if it was only composed of hex digits and an 'H' 
		at the end. This caused unexpected syntax errors with identifiers with 
		only hex digits, e.g. "EACH: NOP" stopped with a syntax error, 
		as EACH was interpreted as the constant 0x0EAC.  
		Changed the scanner to the common processing of hex constants in 
		assemblers: a hex constants ending with an 'H' needs to start with 
		a digit, or be prefixed with a zero.  

- 2014-02-24, pauloscustodio  
Rename "enum symbols" to "tokid_t", define in token.h

- v **2.1.3**, 2014-02-19, pauloscustodio  
	- BUG_0042: 64-bit portability issues  
		size_t changes to unsigned long in 64-bit. Usage of size_t * to 
		retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
		breaks on a 64-bit architecture. Make the functions return the value instead 
		of being passed the pointer to the return value, so that the compiler
		takes care of size conversions.
		
- v **2.1.2**, 2014-02-18, pauloscustodio  
	- BUG_0040: Detect and report division by zero instead of crashing
	- BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0

	- Move generic utility functions to lib/
	- List, StrHash classlist and classhash receive the address of the container
	  object in all functions that add items to the container, and create the
	  container on first use. This allows a container to be statically
	  initialized with NULL and instantiated on first push/unshift/set.
	- Add count attribute to StrHash, classhash to count elements in container.
	- Add free_data attribute in StrHash to register a free function to delete
	  the data container when the hash is removed or a key is overwritten.
	- glib dependency removed from code and Makefile
	- Decouple file.c from errors.c by adding a call-back mechanism in file for
	  fatal errors, setup by errors_init()
	- model.c to hold global data model

- 2014-02-08, pauloscustodio  
lib/srcfile.c to read source files and handle recursive includes,
used to read @lists, removed opts.files;
model.c to hold global data model

- 2014-01-29, pauloscustodio  
Mechanism for atomic file write - open a temp file for writing on
myfopen_atomic(), close and rename to final name on myfclose().
temp_filename() to generate a temporary file name that is
deleted atexit.

- 2014-01-15, pauloscustodio  
Decouple file.c from errors.c by adding a call-back mechanism in file for
fatal errors, setup by errors_init()

- 2014-01-11, pauloscustodio  
Extend copyright to 2014.
Move CVS log to bottom of file.

- 2014-01-11, pauloscustodio  
Astyle - format C code
Add -Wall option to CFLAGS, remove all warnings

- 2014-01-10, pauloscustodio  
Use Str instead of glib, List instead of GSList.
Use init.h mechanism, no need for main() calling init_scan.
glib dependency removed from code and Makefile

- 2014-01-09, pauloscustodio  
Use init.h mechanism, no need for main() calling init_codearea

- 2014-01-09, pauloscustodio  
Use init.h mechanism, no need for main() calling init_options.
Use Str instead of glib.

- 2014-01-05, pauloscustodio  
List, StrHash classlist and classhash receive the address of the container
object in all functions that add items to the container, and create the
container on first use. This allows a container to be staticaly
initialized with NULL and instantiated on first push/unshift/set.
Add count attribute to StrHash, classhash to count elements in container.
Add free_data attribute in StrHash to register a free fucntion to delete
the data container when the hash is removed or a key is overwritten.

- 2014-01-02, pauloscustodio  
Unify interface of classlist and list.

- 2014-01-02, pauloscustodio  
StrList removed, replaced by List

- 2014-01-01, pauloscustodio  
Move generic file utility functions to lib/fileutil.c

2013
----

- v **2.1.1**, 2013-12-30, pauloscustodio  
	- Replace code-generation for init_module() functions by macros in init.h
	  to help define init_module() functions per module.
	  Code generation complicates maintenance, as all the modules with init_module()
	  functions are coupled together, and it may not be clear how the init_module()
	  module appears.
	- Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
	  handles both dynamically allocated strings and fixed-size strings.
	- Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
	  g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.

- v **2.1.0**, 2013-12-15, pauloscustodio  
	- BUG_0039: library not pulled in if XLIB symbol not referenced in expression
		A library must define one XLIB symbol and zero or more XDEF symbols.
		For the library to be pulled in to the linked binary, the XLIB
		symbol needs to be referenced by LIB and used in some expression.
		If one of the XDEF symbols is referenced by XREF and used in an
		expression, the library is not pulled in and the symbol is not found.

	- Move library modules independent from z80asm to the lib subdirectory.
	- Move memory allocation routines to lib/m_malloc, instead of glib,
	  introduce memory leak report on exit and memory fence check.

- v **2.0.0**, 2013-11-26, pauloscustodio  
	- CH_0020: C-like expression syntax instead of old operators
	- Object and Library file version incremented to 02 due to incompatibility
	  with old expression syntax

- v **1.2.10**, 2013-11-26, pauloscustodio  
	- mkinit.pl to generate new main function that calls a set of initializers
	  before user main()
	- Move FileStack implementation to scan.c, remove FileStack.
	- Move getline_File() to scan.c.
	- Move source code generation tools to dev/Makefile, only called on request,
	  and keep the generated files in z80asm directory, so that build does
	  not require tools used for the code generation (ragel, perl).
	- Remove code generation for structs - use CLASS macro instead.

- v **1.2.9**, 2013-10-05, pauloscustodio  
	- New File and FileStack objects
	- Remove legacy xxx_err() interface
	- Renamed SzList to StringList, simplified interface by assuming that
	  list lives in memory util program ends; it is used for directory searches
	  only. Moved interface to strutil.c, removed strlist.c.
	- Removed normalize_eol.
	- Parse command line options via look-up tables.

- v **1.2.8**, 2013-09-12, pauloscustodio  
	- Included GLIB in the Makefile options. Setup GLib memory allocation
	  functions to use m_malloc functions. Unified glib compilation options
	  between MinGW and Linux.
	- Replaced m_malloc et al with glib functions
	- Replaced e4c exception mechanism by a much simpler one based on a few
	  macros. The former did not allow an exit(1) to be called within a
	  try-catch block.
	- Created a code-generation mechanism for automatic execution of initialize
	  code before the main() function starts, and methods for struct malloc
	  and free calling constructors and destructors.
	- Force m_malloc to be the first include, to be able to use MSVC
	  memory debug tools
	- Removed m_malloc allocation checking code, use MSVC _CRTDBG_MAP_ALLOC instead.
	  Dump memory usage statistics at the end if MEMALLOC_DEBUG defined.
	- Replaced strpool code by GLib String Chunks.
	- New error module with one error function per error, no need for the error
	  constants. Allows compiler to type-check error message arguments.
	  Included the errors module in the init_module() mechanism, no need to call
	  error initialization from main(). Moved all error-testing scripts to
	  one file errors.t.
	- Integrate codearea in init_module() mechanism.
	- Create m_free() macro that NULLs the pointer after free, required
	  by z80asm to find out if a pointer was already freed.

- 2013-09-01, pauloscustodio  
  Replaced e4c exception mechanism by a much simpler one based on a few
  macros. The former did not allow an exit(1) to be called within a
  try-catch block.

- v **1.2.7**, 2013-08-30, pauloscustodio  
  - By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
	as an identifier reserved by the C standard for implementation-defined behaviour
	starting with two underscores.

- v **1.2.6**, 2013-08-29, pauloscustodio  
	- __BACKWARDS INCOMPATIBLE CHANGE__, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
	- Expressions now use more standard C-like operators
	- Object and library files changed signature to
	  "Z80RMF02", "Z80LMF02", to avoid usage of old
	  object files with expressions inside in the old format

	Detail:
	- String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
	- Power:                        changed from '^' to '**'; '^' will be XOR
	- XOR:                          changed from ':' to '^';
	- AND:                          changed from '~' to '&';  '~' will be NOT
	- NOT:                          '~' added as binary not

	- CH_0018 : Remove legacy '#' in include file
		According to the z80asm manual, the # sign is used to insert the
		Z80_OZFILES environment variable before the file name, but this
		is not done as the assembler searches for the include file in all
		the include path, which includes the Z80_OZFILES environment variable.
		Handling of '#' in INCLUDE removed.

- v **1.2.5**, 2013-08-26, pauloscustodio  
	- Bug report 2013-07-27 10:50:27 by rkd77: -Wformat -Werror=format-security
		Some distributions build packages with -Wformat -Werror=format-security.
		Build of z88dk fails with these options.

- v **1.2.4**, 2013-08-26, pauloscustodio  
    - Internal clean-up:
		- Symbol_fullname() to return full symbol name NAME@MODULE.
		- get_all_syms() to get list of symbols matching a type mask,
		  use in mapfile to decouple it from get_global_tab()
		- Move deffile writing to deffile.c, remove global variable deffile.
		- New remove_all_{local,static,global}_syms( void ) functions
		  to encapsulate calls to get_global_tab().

- v **1.2.3**, 2013-06-15, pauloscustodio  
	- BUG_0037 : Symbol already defined error when symbol used in IF expression
		The code:  
```
			IF !NEED_floatpack  
				DEFINE	NEED_floatpack  
			ENDIF  
			defb NEED_floatpack  
```
		fails with "Symbol 'NEED_FLOATPACK' already defined"

    - Internal clean-up: Move mapfile writing to mapfile.c.

- v **1.2.2**, 2013-06-15, pauloscustodio  
	- BUG_0036 : Map file does not show local symbols with the same name in different modules
		If the same local symbol is defined in multiple modules, only one of
		them appears in the map file.
		"None." is written in map file if no symbols are defined.

    - Internal clean-up:
		- Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
		- Add error message for invalid symbol and scope chars in object file.
		- find_local_symbol() and find_global_symbol() to encapsulate usage of get_global_tab()

- v **1.2.1**, 2013-06-11, pauloscustodio  
	- BUG_0035 : Symbol not defined in forward references
		Symbol not defined error when a symbol is used more than once before
		being defined. Consequence of removal of notdecl_tab symbol table.

	- CH_0023 : Remove notdecl_tab
		Symbol is created in symbol table on first usage, is_defined
		identifies if it was defined or not.

- 2013-06-10, pauloscustodio  
CH_0023 : Remove notdecl_tab

- 2013-06-08, pauloscustodio  
Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
Define keywords for special symbols ASMSIZE, ASMTAIL

- v **1.2.0**, 2013-06-01, pauloscustodio  
	- BUG_0032 : DEFGROUP ignores name after assignment
		The code  
```
			DEFGROUP {  
				f10 = 10, f11  
			}  
```
		did not define f11 - all text after the expression was discarded.

	- BUG_0033 : -d option fails if .asm does not exist  
		When building test.o from test.c, the test.asm file is removed by zcc.
		If the .o is then linked into a library with the -d option to skip
		assembling, z80asm fails with error
		"Cannot open file 'test.asm' for reading".
		Bug introduced when replaced TestAsmFile() by query_assemble() in
		z80asm.c 1.78.

	- BUG_0034 : If assembly process fails with fatal error, invalid library is kept  
		Option -x creates an empty library file (just the header). If the
		assembly process fails with a fatal error afterwards, the library file
		is not deleted.

	- CH_0020 : ERR_ORG_NOT_DEFINED if no ORG given  
		z80asm no longer asks for an ORG address from the standard input
		if one is not given either by an ORG statement or a -r option;
		it exists with an error message instead.
		The old behaviour was causing wrong build scripts to hang waiting
		for input.

	- CH_0021 : Exceptions on file IO show file name  
		Keep a hash table of all opened file names, so that the file name
		is shown on a fatal error.
		Rename file IO funtions: f..._err to xf...

	- CH_0022 : Replace avltree by hash table for symbol table  
		Replaced avltree from original assembler by hash table because:
		a) code simplicity
		b) performance - avltree 50% slower when loading the symbols from the
		   ZX 48 ROM assembly, see t\developer\benchmark_symtab.t
		Removed unused errors, replaced by assertion, code not reached:
		ERR_SYMBOL_DECL_GLOBAL, ERR_SYMBOL_DECL_EXTERN.
		Replaced error ERR_SYMBOL_REDECL_GLOBAL (not reached in compile phase)
		by ERR_SYMBOL_REDEFINED_MODULE (was printf).

    - Internal clean-up:
		- Decouple assembler from listfile handling
		- Uniform the APIs of classhash, classlist, strhash, strlist
		- New model_symref.c with all symbol cross-reference list handling
		- Simplified symbol output to listfile by using SymbolRefList argument
		- Renamed StrList to SzList to solve conflict with CLASS_LIST( Str )
		  also generating a class StrList
		- New srcfile.c to handle reading lines from source files
		- Move include path search to srcfile.c
		- New interface to Str to copy characters to string
		- New __LEGACY_Z80ASM_SYNTAX define to mark code that should be removed but is kept
		  to keep backwards compatibility
		- Removed writeline, that was used to cancel listing of multi-line
		  constructs, as only the first line was shown on the list file. Fixed
		  the problem in DEFVARS and DEFGROUP. Side-effect: LSTOFF line is listed.
		- Removed pass1 that was used to skip creating page references of created
		  symbols in pass2. Modified add_symbol_ref() to ignore pages < 1,
		  modified list_get_page_nr() to return -1 after the whole source is
		  processed.
		- GetLibfile(), ReadName(), ReadNames(), CheckIfModuleWanted(),
		  LinkLibModules(), SearchLibFile() were using global z80asmfile instead
		  of a local FILE* variable - fixed
		- CreateDeffile() : no need to allocate file name dynamically, use a stack variable
		- Move libfilename to options.c, keep it in strpool
		- Helper functions to create file names of each of the extensions used in z80asm
		- Remove global variable errfilename
		- DEFINE_STR() caused compilation error "C2099: initializer is not a constant"
		  when used to define global variables
		- Move default asm and obj extension handling to file.c.
		- srcfilename and objfilename are now pointers to static variables in file.c
		- Removed global variable smallc_source, no longer used
		- ENDIAN not used and logic to define it was causing Deprecated warnings - removed
		- Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
		- Add utility functions to get N characters from input, return FALSE on EOF
		- New module for object file handling
		- New MAXIDENT for maximum identifier length - set at 255 because of
		  object file format with one byte string length
		- New MIN and MAX macros
		- Move symbol to sym.c, rename to Symbol
		- StrHash_set failed when the key string buffer was reused later in the code.
		  StrHash_get failed to retrieve object after the key used by StrHash_set
		  was reused.

- v **1.1.22**, 2013-02-16, pauloscustodio  
	- BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode  
		When the instruction assembles more than 4 bytes (e.g. defb), the
		assembly line is not aligned in the list file.
		The size of the EOL character was not taken into account in
		computing the list file patch address for the assembly bytes on the
		second and next lines, for more than 32 bytes instructions.

- v **1.1.23**, 2013-02-19, pauloscustodio  
	- BUG_0030 : List bytes patching overwrites header  
		When instruction is more than 32 bytes and second line of bytes is
		on a different page, the expression bytes are patched on the header
		line, because the offsets to the start of the list line stored in the
		expression are no longer true.

	- BUG_0031 : List file garbled with input lines with 255 chars  
		When the input line is the maximum size, the newline character is not
		read from file and the list output is garbled - missing newline.

    - Internal clean-up:
		- New listfile.c with all the listing related code

- v **1.1.21**, 2013-02-12, pauloscustodio  
	- BUG_0026 : Incorrect paging in symbol list  
		The pages including the header of each symbol list had one line less
		than the others - incorrect call of LineCounter().

	- BUG_0027 : Incorrect tabulation in symbol list  
		When symbols are longer than COLUMN_WIDTH by 1, one extra tab is
		output between symbol name and '=' sign.
		See CH_0017.

	- BUG_0028 : Not aligned page list in symbol list with more that 18 references  
		The page list of each symbol at the end of the list file is not aligned
		when there are more than 18 references of a symbol.
		The first line has 18 references, the next lines have 17.
		The '*' causes the 2nd and next lines to have misaligned references.

	- CH_0017 : Align with spaces, deprecate -t option  
		Replace TAB-printing logic by printf() field length specifier.
		Simpler code at the expense of longer output files, using spaces instead
		of TABs.
		Change list file, sym file, map file and def file.
		Change page metrics variables into constants.

    - Internal clean-up:
		- Unified usage of integer types: int, char, Byte
		- New CLASS_LIST() to create lists of objects defined by CLASS()
		- New CLASS_HASH() to create hash tables of objects defined by CLASS()

- v **1.1.20**, 2013-01-20, pauloscustodio  
    - CH_0015 : integer out of range error replaced by warning  
		C compiler generates code "ld bc,-50000" which was causing the assembly
		to abort. Replace by warning message but assemble value.
		Warnings on ERR_INT_RANGE, ERR_INT_RANGE_EXPR.

    - CH_0016 : StrHash class to create maps from string to void*  
		Created the StrHash to create hash tables mapping string keys kept in
		strpool to void* user pointer. This will be used to solve BUG_0023.

	- BUG_0023 : Error file with warning is removed in link phase  
		z80asm -b f1.asm
		If assembling f1.asm produces a warning, the link phase removes the f1.err
		file hiding the warning.

	- BUG_0024 : (ix+128) should show warning message  
		Signed integer range was wrongly checked to -128..255 instead
		of -128..127

	- BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()  
		jr instruction on address 0, with out of range argument ->
		jr calls error and writes incomplete opcode (only one byte);
		WriteListFile tries to list bytes from -1 to 1 -> crash

2012
----

- v **1.1.19**, 2012-11-03, pauloscustodio  
    - BUG_0022 : Different behaviour in string truncation in strutil in Linux and Win32  
        Linux vsnprintf always writes the null terminator, therefore requires
        buffer size as argument.
        Win32 vsnprintf writes the null terminator only if there is room at the
        end, and needs the null terminator to be added in case of buffer full.

    - CH_0014 : New Dynamic Strings that grow automatically on creation / concatenation  

    - Internal clean-up:
		- Make mapfile static to module modlink.
		- Remove modsrcfile, not used.
		- GetModuleSize(): use local variable for file handle instead of objfile
		- stricompare() instead of Flncmp().
		- Split safe strings from strutil.c to safestr.c.
		- Use _MSC_VER instead of WIN32 for MS-C compiler specific code.

- v **1.1.18**, 2012-11-01, pauloscustodio  
    - BUG_0021 : need sign extension in 64-bit architectures  
        Reading of object files failed in 64-bit architectures because
        0xFFFFFFFF was being checked against -1, which is true in 32-bit
        but not in 64-bit.

- v **1.1.17**, 2012-06-05, pauloscustodio  
    - BUG_0020 : Segmentation fault in ParseIdent for symbol not found with interpret OFF  
        When a symbol is not found and interpret is OFF, the exception condition
        is not detected and a NULL pointer is dereferenced.

- v **1.1.16**, 2012-05-31, pauloscustodio  
    - BUG_0019 : z80asm closes a closed file handle, crash in Linux  
        GetModuleSize() opens and closes the objfile, but keeps objfile
        as a stale FILE*. CloseFiles() closes any file that has a non-null
        FILE*, trying to close objfile again. This crahes in Linux.

- v **1.1.15**, 2012-05-26, pauloscustodio  
    - BUG_0018 : stack overflow in '@' includes - wrong range check  
        if (include_level < sizeof( includes ) - 1) compares size in bytes, not
        number of elements

    - CH_0009 : define simple classes with ordered construction and destruction  
        Simple classes defined in C with constructor, destructor and copy
        constructor defined.
        All objects that were not deleted during the program execution
        are orderly destroyed at the exit, i.e. by calling the destructor of
        each object, which in turn may call destructors of contained objects.

    - CH_0010 : new string pool to hold strings for all program duration  
        Keep pool of strings for all duration of the program.
        Most keywords in input program are the same, no need to keep several copies
        and manage strdup/free for each token.
        Strings with the same contents are reused.

    - CH_0011 : new string list class to hold lists of strings  
        Used to keep the include and lib search paths.
        Remove the global variables include_dir, lib_dir, and respective
        counts, create instead the paths in the options module and
        create new search_include_file() and search_lib_file()
        functions to replace SearchFile().

    - CH_0012 : wrappers on OS calls to raise fatal error  
        Remove all the checks for failure after fopen(), localize the error
        checking and fatal error in myfopen().
        Removed exception FileIOException and ERR_FILE_IO error.

    - CH_0013 : new errors interface to decouple calling code from errors.c  
        Hide the global variables TOTALERRORS and errfile, throw FatalErrorException
        inside errors.c's new interface, to simplify the calling code.
        New interface to declare current error location to the error module,
        decouple errors.c from the internal knowledge of the z80asm data
        structures.
        Uniform error message format, with file at compile time and module
        at link time.
        New ERR_EXPR, ERR_INT_RANGE_EXPR, ERR_NOT_DEFINED_EXPR at link time
        to remove old hack of writing the faulty expression directly to the
        errfile file handle.
        Error numbers are no longer fixed, test files now have the error name
        and errors_def.h defines the errors in any order, that is used in errors.h
        to define the error code and in errors.c the error string.
        Remove ERR_NO_ERR, not used.
        Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
        ERR_EXPR_SYNTAX renamed ERR_SYNTAX_EXPR (consistency).
        New ERR_RUNTIME for unexpected RuntimeException.
        Replace ERR_FILE_IO by ERR_FILE_READ and ERR_FILE_WRITE
        Remove ERRORS, redundant with TOTALERRORS.

    - Internal clean-up:
		- Rename safestr_t to sstr_t, keep length to speed-up appending chars.
		- Make invalid option error fatal.
		- Let garbage collector do memory release atexit().
		- Included uthash.h by Troy D. Hanson http://uthash.sourceforge.net
		- New search_file() to search file in a StrList.
		- Remove EarlyReturnException, FileIOException: no longer used.
		- Put back strtoupper, strupr does not exist in all systems,
		  was causing nightly build to fail
		- Replaced xfputc and friends with xfput_u8, raising a fatal_error()
		  instead of an exception, moved to errors.c.

- v **1.1.14**, 2012-05-22, pauloscustodio  
    - CH_0007 : Garbage collector  
      Added automatic garbage collection on exit and simple fence mechanism
      to detect buffer underflow and overflow, to m_malloc functions.
      No longer needed to call init_malloc().
      No longer need to try/catch during creation of memory structures to
      free partially created data - all not freed data is freed atexit().
      Renamed xfree0() to m_free().

    - CH_0008 : Safe strings  
      New type sstr_t to hold strings with size to prevent buffer overruns.

    - Internal clean-up:
		- Included OpenBSD queue.h
		- New init_except() to be called at start of main(), auto clean-up atexit().
		- New die() and warn().
		- New types.h with common types.
		- Remove global ASSEMBLE_ERROR, not used.
		- Remove global ASMERROR, redundant with TOTALERRORS.
		- Remove IllegalArgumentException, replace by FatalErrorException.
		- define_symbol() defined as void, a fatal error is
		  always raised on error.
		- New errors_def.h with error name and string together, for easier
		  maintenance.
		- ParseIndent(): remove hard coded IDs of IF, ELSE, ENDIF
		- Z80ident[]: make always handling function the same name as assembler ident.
		- Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
		- ERR_SYMBOL_DECL_GLOBAL seams to be impossible to get. Added comment on this,
		  changed test error-18.t.
		- Added tests

- v **1.1.13**, 2012-05-12, pauloscustodio  
    - BUG_0016 : RCMX000 emulation routines not assembled when LIST is ON (-l)  
        The code "cpi" is assembled as "call rcmx_cpi" when option -RCMX000 is ON.
        This is implemented by calling SetTemporaryLine() to insert new code
        at the current input position.
        When LIST is ON, getasmline() remembers the input file position, reads
        the next line and restores the file position. It ignores the buffer
        set by SetTemporaryLine(), causing the assembler to skip
        the "call rcmx_cpi" line.
        Also added registry of rcmx_cpi as external library routine.

    - Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets,
      spaces instead of tabs, indenting style, space padding in parentheses and
      operators. Options written in the makefile, target astyle.
        --mode=c
        --lineend=linux
        --indent=spaces=4
        --style=ansi --add-brackets
        --indent-switches --indent-classes
        --indent-preprocessor --convert-tabs
        --break-blocks
        --pad-oper --pad-paren-in --pad-header --unpad-paren
        --align-pointer=name

    - Added testcase for ASMSIZE/ASMTAIL

- 2012-04-05 (stefano)
    - CH_0006 : New reserved words ASMTAIL and ASMSIZE  
        New stuff for z80asm  
        I just put in the version under development of z80asm a couple of lines to
        handle two new reserved words: ASMTAIL and ASMSIZE.
        In my intention ASMTAIL could e used to define a good position for malloc()
        or for a stack overflow protection routine.

2011
----

- v **1.1.12**, 2011-10-14, pauloscustodio  
    - BUG_0013 : defm check for MAX_CODESIZE incorrect  
      The code:  
```
            defs 65535, 'a'  
            defm "a"  
```

          fails with: ```Error: File 'test.asm', at line 3, Max. code size of
          65536 bytes reached```

    - Remove unnecessary tests for MAX_CODESIZE; all tests are concentrated in
        check_space() from codearea.c.
    - Replace strncpy by strncat, when used to make a safe copy without buffer
        overruns. The former pads the string with nulls.
    - Move cpu_type to options.c.
    - Factor strtoupper() to new module strutil.c.
    - New path_basename() in file.c, change functions to return result string
        pointer.
    - Silence warnings with casts.

- v **1.1.11**, 2011-10-07, pauloscustodio  
    - BUG_0015 : Relocation issue - dubious addresses come out of linking
    (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)  
        - Introduced in version 1.1.8, when the CODESIZE and the codeptr
          were merged into the same entity.
        - This caused the problem because CODESIZE keeps track of the start
          offset of each module in the sequence they will appear in the object
          file, and codeptr is reset to the start of the codearea for each module.
          The effect was that all address calculations at link phase were
          considering a start offset of zero for all modules.
        - Moreover, when linking modules from a library, the modules are pulled
          in to the code area as they are needed, and not in the sequence they
          will be in the object file. The start offset was being ignored and
          the modules were being loaded in the incorrect order
        - Consequence of these two issues were all linked addresses wrong for
          programs with more that one module.

- v **1.1.10**, 2011-09-30, pauloscustodio  
    - BUG_0014 : -x./zx_clib should create ./zx_clib.lib but actually creates .lib
    (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)  
          path_remove_ext() removed everything after last ".", ignoring directory
          separators. Fixed.

    - asm_ext initialization moved from main() to reset_options()

- v **1.1.9**, 2011-09-29, pauloscustodio  
    - BUG_0012 : binfilename[] array is too short, should be FILENAME_MAX

    - CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
        - Factor all pathname manipulation into module file.c.
        - Make default extensions constants.
        - Factor FILEEXT_SEPARATOR into config.h.
        - Move asm_ext[] and obj_ext[] to the options.c module.

- v **1.1.8**, 2011-08-19, pauloscustodio  
    - BUG_0008 : code block of 64K is read as zero  
        - When linking a module with 64K of data no data is read from the
          object file because the code size is stored with two bytes = zero.
        - Problem is masked if the module with 64K is the only module linked
          because the linker reuses the code block left by the assembler,
          which still contains the code.

    - BUG_0009 : file read/write not tested for errors  
        - In case of disk full file write fails, but assembler does not
          detect the error and leaves back corrupted object/binary files
        - Created new exception FileIOException and ERR_FILE_IO error.
        - Created new functions xfput_u8, xfget_u8, ... to raise the
          exception on error.

    - BUG_0010 : heap corruption when reaching MAXCODESIZE  
        - test for overflow of MAXCODESIZE is done before each instruction at
          parseline(); if only one byte is available in codearea, and a 2 byte
          instruction is assembled, the heap is corrupted before the
          exception is raised.
        - Factored all the codearea-accessing code into a new module, checking
          for MAXCODESIZE on every write.
        - Side effect of this fix: object files now store a zero on every location
          in code that will be patched by the linker, before they stored random
          data - whatever was in memory at that location in codearea.

        - Upgrade to Exceptions4c 2.8.9 to solve memory leak.
        - Factored code to read/write word from file into xfget_u16/xfput_u16.
        - Renamed ReadLong/WriteLong to xfget_i32/xfput_u32 for symmetry.

- v **1.1.7**, 2011-08-14, pauloscustodio  
    - CH_0004(a) : Exception mechanism to handle fatal errors  
        - New exception FatalErrorException to raise on fatal assembly errors
        - ReportError(), link_modules(), ModuleExpr(), CreateBinFile(),
          CreateLib(), INCLUDE(), BINARY(): throw the new exception
          FatalErrorException for fatal errors ERR_FILE_OPEN and ERR_MAX_CODESIZE
        - AssembleSourceFile(): added try-catch to delete incomplete files
          in case of fatal error, throw FatalErrorException instead of early
          return.
        - main(): added try-catch to delete incomplete library file in case of
          fatal error.
        - parse_file(), INCLUDE(): no need to check for fatal errors and return;
          bypassed by the exception mechanism.
        - AssembleSourceFile(): error return is never used; changed to void.
        - source_file_open flag removed; z80asmfile is used for the same purpose.
        - Tests: Added test case to verify that incomplete files are deleted on error.
        - Hack to hide memory leak in e4c, line 647, when rethrow() is called.
          Reported to Exceptions4c project page http://code.google.com/p/exceptions4c/

- v **1.1.6**, 2011-08-05, pauloscustodio  
    - CH_0004 : Exception mechanism to handle fatal errors
        - Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
        - Replaced all ERR_NO_MEMORY/return sequences by an exception,
          captured at main().
        - Replaced all the memory allocation functions malloc, calloc, ...
          by corresponding macros m_malloc, m_calloc, ... that raise an exception
          if the memory cannot be allocated, removing all the test code after
          each memory allocation.
        - Replaced all functions that allocated memory structures by the new
          xcalloc_struct().
        - Replaced all free() by xfree0() macro which only frees if the pointer
          is non-null, and sets the poiter to NULL afterwards, to avoid any use
          of the freed memory.
        - Created try/catch sequences to clean-up partially created memory
          structures and rethrow the exception, to cleanup memory leaks.
        - Replaced all exit(1) by an exception.
        - Replaced 'l' (lower case letter L) by 'len' - too easy to confuse
          with numeral '1'.

- v **1.1.5**, 2011-07-18, pauloscustodio  
    - BUG_0007 : memory leaks
        - Included code to run MS Visual Studio memory leak detection on a DEBUG
          build.
        - Cleaned memory leaks in main(), ReleaseModules(), DEFS().
        - Still memory leaks in main() in case of premature exit due to fatal
          errors;
          need to include exception mechanism to solve.

- v **1.1.4**, 2011-07-15, pauloscustodio  
    - BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced
        in tokid_t, causing expressions stored in object files to be wrong,
        e.g. VALUE-1 was stored as VALUE*1. This caused problems in expression
        evaluation in link phase.

- v **1.1.3**, 2011-07-14, pauloscustodio  
    - Moved all error variables and error reporting code to a separate module
      errors.c, replaced all extern declarations of these variables by include
      errors.h, created symbolic constants for error codes.
    - Added test scripts for error messages.
    - Unified "Integer out of range" and "Out of range" errors; they are the
      same error.
    - Unified ReportIOError as ReportError(ERR_FILE_OPEN).

    - CH_0003 : Error messages should be more informative  
      Added printf-args to error messages, added "Error:" prefix.

    - BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)  
      Raise ERR_UNBALANCED_PAREN instead.

- 2011-07-12, pauloscustodio  
  - Moved all error variables and error reporting code to a separate module errors.c,
    replaced all extern declarations of these variables by include errors.h,
    created symbolic constants for error codes.
  - Added test scripts for error messages.

- v **1.1.2**, 2011-07-11, pauloscustodio  
    - Copied cvs log into Log history of each file, added Z80asm banner
      to all sources.
    - Moved all option variables and option handling code to a separate
      module options.c, replaced all extern declarations of these variables
      by include options.h.
    - Added test scripts for all z80asm options.
    - Created declarations in z80asm.h of objects defined in z80asm.c.
    - Created declarations in symbols.h of objects defined in symbols.c.
    - Updated z80asm.html: indication of deprecated error messages,
      links within the document.
    - Removed references to dead variable 'relocfile'.

- v **1.1.1**, 2011-07-09, pauloscustodio  
  **Based on 1.0.31**

    Compiled with Visual C++ 2010, added casts to clean up warnings.
	
    Moved version strings to this file, created hist.h, for easy maintenance.
	
    Created HTML version of doc/z80asm.txt as doc/z80asm.html:
      - added table of contents to help looking up information
      - added documentation for options:
             -RCMX000, -plus, -IXIY, -C, -h, -I, -L, -sdcc
      - added documentation for commands: INVOKE, LINE
      - added notes on deprecated error messages
	  
    Started to build test suite in t/ *.t unsing Perl prove. Included test
    for all standard Z80 opcodes; need to be extended with directives and
    opcodes for Z80 variants.

    - BUG_0001 : Error in expression during link, expression garbled - memory corruption?  
         Simple asm program: "org 0 \n jp NN \n jp NN \n NN: \n",
         compile with "z80asm -t4 -b test.asm"
         fails with: "File 'test.asm', Module 'TEST', Syntax error in expression \n
                      Error in expression +¦+²+-;¾?.¹Ò¦Ò²Ù+vÝFÝVÝ^Ýx¦ Ý@ÝHÝPÝ".

         Problem cause: lexer GetSym() is not prepared to read '\0' bytes.
         When the expression is read from the OBJ file at the link phase,
         the '\0' at the end of the expression field is interpreted as a
         random separator because ssym[] contains fewer elements (27)
         than the separators string (28); hence in some cases the expression
         is parsed correctly, e.g. without -t4 the program assembles correctly.
         If the random separator is a semicolon, GetSym() calls Skipline()
         to go past the comment, and reads past the end of the expression
         in the OBJ file, causing the parse of the next expression to fail.

    - BUG_0002 : CreateLibFile and GetLibFile: buffer overrun  
         When the Z80_STDLIB variable is defined, libfilename is allocated
         with one byte too short (strlen(filename) instead of strlen(filename)+1).

    - BUG_0003 : Illegal options are ignored, although ReportError 9 (Illegal Option) exists  
         set_asm_flag(): Some options were missing the 'return' statement,
         following through to the next tests; inserted 'return'
         in options 'M', 'I', 'L' and 'D'.
         Added ReportError 9 (Illegal Option) if the option is not recognized.

    - CH_0001 : Assembly error messages should appear on stderr  
         It's cumbersome to have to open .err files to see assembly errors.
         Changed ReportError() to Write error messages to stderr in addition
         to the .err file.

    - BUG_0004 : 8bit unsigned constants are not checked for out-of-range  
         Added the check

    - BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary  
         Accept (ix) and (iy), use offset zero.
         Raise syntax error for (ix 4), was accepting as (ix+4).

    - CH_0002 : Unary plus and unary minus added to Factor()  
         Accept unary minus and unary plus in factor to allow (ix+ -3) to be
         parsed as (ix-3).

2002
----

- 2002-04-22, stefano  
Removed the SLL L undocumented instructions from the Graph library.
NEW startup=2 mode for the ZX81 (SLOW mode... hoping we'll make it work in the future).
MS Visual C compiler related fixes
-IXIY option on Z80ASM to swap the IX and IY registers

- 2002-04-22 [no version increment] (Stefano)  
IX <-> IY swap option added (-IXIY)

- 2002-01-18, dom  
0x prefix allowed for hex constants

- 2002-01-18, dom  
added 'd' and 'b' identifiers for constants - decimal and binary
respectively.

- 2002-01-18, dom  
```***``` empty log message ```***```

2001
----

- 2001-06-27, dom  
Added a second parameter to defs to indicate what the filler byte should be

- 2001-06-27 [no version increment] (djm)  
defs now takes a second parameter indicating what the filler byte should be, if not
set the defaults to 0

- 2001-03-21, dom  
Added changes to allow labels to end in ':' and the prefix '.' isn't
necessarily needed..this isn't guaranteed to be perfect so let me know
of any problems and drop back to 1.0.18

- 2001-03-21 v1.0.19 (djm)  
Allowed labels to end in ':' and forsake the initial '.'

- 2001-02-28, dom  
Fixed size of Z80ident table <grrr>

- 2001-02-28 V1.0.18 (djm)  
Added UNDEFINE command to allow undefinition of a DEFINE

- 2001-01-23, dom  
Changes by x1cygnus:  
just added a harcoded macro Invoke, similar to callpkg except that the
instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
the parameter -plus is specified on the command line.  
Changes by dom:  
Added in a rudimentary default directory set up (Defined at compile time)
a bit kludgy and not very nice!

- 2001-01-20 <x1cygnus@xcalc.org> [No version increment]  
Added hardcoded macro instruction Invoke and command line ti83plus
to make assembler ti83/83plus compatible

- 2001-01-18 [no version increment] (djm)  
Dropped the requirement for add, sbc, and adc to specify "a," for 8 bit
operations  
Added d and b specifiers for constants - decimal and binary
C-style 0x prefix for hex digits is permitted

- 2001-01-17 [no version increment] (djm)  
20h is now accepted as a synonym for $20

2000
----

- 2000-07-04, dom  
First import of z88dk into the sourceforge system <gulp>

- 2000-04-23 (djm) [No version increment]  
Added auto ENDIAN config if using GNU C

- 2000-02-26, V1.0.17 (djm)  
Added -C flag to output C source line number instead of asm line number
(if defined)  
Added directive LINE <expr> to enable this  
Allowed labels to start with an ' _ '

- 2000-01-30, V1.0.16 (gbs)  
Dominic's -M option extended with argument, so that it may be possible
to define an arbitrary object file extension (max 3 chars), e.g. -Mo to define .o extension.

- 2000-01-28, V1.0.15 (dom)  
Fixed ParseIdent routine (was searching for IF,ELSE,ENDIF at one
position below there true place in the table) - this zapped
the HALT instruction and caused a Syntax Error report  
Added the -M flag the change output files to .o from .obj

- 2000-01-26, V1.0.14 (gbs)  
Expression range validation removed from 8bit unsigned (redundant) data storage.

1999
----

- 1999-10-03, V1.0.13 (gbs)  
Slight change to CALL_PKG(): 0 (zero) is allowed as parameter.

- 1999-09-30, V1.0.13 (gbs)  
CALL_PKG hard coded macro implemented for Garry Lancaster's Package system.

- 1999-06-06, V1.0.12 (gbs):  
MAXCODESIZE define moved to "config.h" where it also is defined for specific platforms.
For MSDOS the value is 65532 due to max heap size allocation per malloc() call.
(MSDOS BorlandC limitation reported by Dennis Gröning <dennisgr@algonet.se>)  
DEFB, DEFW, DEFL & DEFM now implemented with proper MAXCODESIZE checking.
ReportError() now displays to stderr the actual MAXCODESIZE limit if it has been reached.

- 1999-05-30, V1.0.11 (gbs):  
Binary() rewritten due to misbehaving functionality on MSDOS platform.
(reported by Keith Rickard, keithrickard@compuserve.com).  
CreateLib() rewritten to replace the open() low level file I/O with high level
fopen() and fread() calls.

- 1999-05-04, V1.0.10 (gbs):  
Bug fixes related to reading filenames from source files (filenames should not be case converted
because some filing systems look at filenames explicitely - with no case independency).  
During create library, object offset now only displayed in verbose mode.  
Filenames may now be specified with .asm at command line (stripped again internally). This is
useful since some OS's have true command line expansion, now allowing "z80asm *.asm" to get
all assembler source files pre-assembled.

- 1999-05-02, V1.0.9 (gbs):  
Directives XDEF, XREF, XLIB and LIB can now be defined arbitrarily in the asm source (before or after
the actual symbols names in question). Request by Dominic Morris of SmallC fame.  
"LINUX" OS ID now changed to generic "UNIX" in compilation, since there's no Linux specifics in the
sources. Further, all UNIX's can successfully compile and execute z80asm.  
Recursive include of same or mutual files now error trapped (new FindFile() function and changes to
INCLUDE() function).

- 1999-04-30, V1.0.8 (gbs):  
Error messages now extended with display of module name, if possible (request by Dominic Morris)
Basic file I/O error reported in new error message function to display proper error message.

- 1999-04-16, V1.0.7 (gbs):  
Assembler parses text files of arbitrary line feed standards; CR, LF or CRLF (OS independant text file parsing).  
Command line symbol option to identify project files, #, has been changed to @ because # is regarded
as comment line identifier in UNIX shell environments - the result of this means that the file name is
discarded by the command line environment, when trying to compile a z80asm project.  
Default -v option changed to -nv (verbose mode disabled by default).

- 1999-04-11, V1.0.6 (gbs):  
C sources modified slighly a few lines to eliminate -Wall compiler warnings when using GNU C compiler
on Linux (now truly ANSI C conformant). All sources now reformatted according to GNU C programming style.  
New option added: -o<filename> which allowes a different binary outfilename than otherwise based on
project filename.

- 1999-03-07, V1.0.5 (dom):  
Program terminates with 1 if an error occurs, otherwise 0 (implemented by Dominic Morris djm@jb.man.ac.uk).  
Minor changes to remove silly warnings.

1998
----

- 1998-09-03, V1.0.4 (gbs):  
New command line option added: Use self defined source file extension, -e<ext> in stead of ".asm".
DEFVARS functionality extended with -1 which remembers last used offset.

- 1998-06-20, V1.0.3 (gbs):  
Minor bug fixes in EOF handling in prsline.c, exprprsr.c and asmdrctv.c  
prsident.c : SUB, AND, OR, XOR and CP instructions improved with "instr [A,]" syntax (allowing to specify "A,"
explicitly and thereby avoiding mis-interpretations).

1996
----

- 1996-02-20, V1.01 (gbs):  
Minor bug fixed for signed 8bit operands:  
If say, LD (IX+$FF),A were used, the assembler gave an error. It shouldn't. The operand is now properly
sign-converted.

1995
----

- 1995-11-14, V1.00:  
Last changes before final release:  
Syntax check on register mnemonics improved.
XLIB improved to issue implicit MODULE definition.

- 1995-07-13, V0.60:  
Syntax parsing improvement in DEFB, DEFW and DEFL directives.

- 1995-06-28, V0.59:  
New Relocator routine implemented. Mapfile now adds relocation header offset to address labels if
relocation option, -R, was selected).

- 1995-06-22, V0.58:  
Parsing logic improved, with a bugfix in IF conditional expressions: A comment after a conditional
expression wasn't skipped. Getsym() has now been improved to skip the rest of a line of a comment ; is found.  
This has also lead to various improvements in the parsing logic code of the assembler.  
Total of lines assembled is now also displayed after successfull compilation.

- 1995-06-03, V0.57:  
compile option messages displayed before processing (response to selected command line option).
EvalExpr() slightly optimised: Identifier logic in expressions made faster.

- 1995-05-03, V0.56:  
DEFGROUP improved; evaluable expressions may now be used (previously only constants).

- 1995-04-27, V0.55:  
-c option added, which split the compiled machine code into 16K blocks. Each file is identified
with a '_bnx' extension where 'x' defines the blocks 0 (the first) to 3 (total of 64K).

- 1995-04-25, V0.54:  
standard avltree move() and copy() now used in stead of CopyTree() and ReorderSymbol().

- 1995-04-24, V0.53:  
'ASMPC' standard identifier now implemented as part of the global symbol tables. This means that
that it is equal to all other created symbols. Both pass1(), pass2() and the linking process use the assembler PC.  
The explicit code in define_symbol() and Factor() are finally removed, which has speeded up the algorithms.

- 1995-04-21, V0.52:  
New avltree algorithms used in Z80asm. Many symbol-related routines changed to new interface.
Forward-referenced symbols now finally deleted, in stead of being marked SYMREMOVED. find_symbol() now faster.

- 1995-03-17:   
ORG is now only defined from keyboard at the beginning of the linking process, if no ORG
were defined during assembly of the first module.

- 1995-03-14, V0.50:  
Bug in Condition() fixed: logical NOT algorithm were misplaced. Moved to Factor().  

- 1995-03-12:  
Patching on 16bit addresses optimized.

- 1995-03-03:  
Evaluation stack algorithms optimized.

- 1995-01-05:  
Bug in -D option fixed: first character of identifier wasn't converted to upper case.

- 1995-01-01, V0.49:  
New feature in expressions implemented: Leading '#' in expressions defines a constant expression.
This is necessary when calculating relocatable address offsets and avoiding it to be interpreted as a relocatable address to be manipulated during a -R option.  
'#ASMPC' changed to 'ASMPC'

1994
----

- 1994-11-30, V0.48:  
Library filenames may now be omitted which is interpreted as the standard library filename.
Since the standard library is used most of the time it is considerably easier to just specify '-i' or '-x' without a filename.  
The default library filename is defined in an environment variable 'Z80_STDLIB'.

- 1994-11-18, V0.47:  
The following undocumented Z80 instructions have been implemented:  
SLL instruction (Shift Logical Left).  
8Bit LD r,IXh/IXl/IYl/IYh & LD IXh/IXl/IYl/IYh,r.  
INC/DEC IXl,IXh,IYl,IYh.  
AND, ADD, ADC, SUB, SBC, CP, OR & XOR IXl/IXh/IYl/IYh.

- 1994-11-17, V0.46:  
Expression parsing & evaluation added with ^ (power) operator. Binary XOR now uses the ':' symbol.
The power operator is useful it may be necessary to convert bit numbers 0-7 into an 8bit value using: 2^bitnumber.

- 1994-11-01:  
-i option opened the library file with unnecessary mode flags. If the specified library
file didn't exist, it was automatically created. The routine then made the wrong assumptions 
of that file.

- 1994-10-31:  
Relocator & relocation table structure changed. Each entry in the table is now defined
as offsets from each relocation address. Since relocation addresses mostly are less than 255 bytes
apart, this design saves a lot of space on the relocation header, about 50%. The idea was suggested by
Erling Jacobsen who noticed the principle in the C68 C compiler.  
The relocation table contents allowes negative offsets. This may be useful since not all relocation
code patch pointers is historically organised. However, if two adjacent patch pointers are more than
32K apart it will not create the proper offset pointer (due to an integer overflow).

- 1994-10-19, V0.45:  
New option added: -R. This Feature generates relocatable code, i.e. relocates it self before being
executed. A standard machine code routine is put in front of the code together wth a relocation table.
The generated machine code is self modifying and may only be executed in RAM (e.g.in Z88 BBC BASIC).
The help page has been slighty improved.

- 1994-09-27  
LSTON/LSTOFF bug fixed: During INCLUDE file management, the old line of the previous file was written 
to the list file when beginning/continuing on a new file. The listing file line is now initially 
cleared before pass 1 is executed.

- 1994-09-22, V0.42:  
INCLUDE directive improved: Environment variable "Z80_OZFILES" introduced to read a fixed path of all
Z88 OZ definition files. This makes it easier to port source code with regard to fetch the standard
OZ files. Each platform just presets the variable and the assembler will automatically expand the
system file '#file' with a leading path followed by 'file'.  
O_BINARY mode included in open() function when creating a library file. This ensures compatibility
with MSDOS files.  
Bug in Z80asm_c fixed: -x option created library file as text file (no binary open mode). The file is
now created as a binary file. NB: This is only relevant for MSDOS (and LINUX/UNIX?).

- 1994-09-16, V0.41:  
Size specifier in DEFVARS variable offset may now be specified as an expression. However, the
expression may not contain forward referenced symbols. The algorithm has been re-structurized.

- 1994-06-17, V0.40:  
DEFVARS origin parameter may now be an expression (with no forward references) Default tabulator
distance now set to 8, column width is 4 times t. distance.

- 1994-06-15  
Internal improvement of module & library linking routines.

- 1994-06-07, V0.39:  
Symbol file implemented. This will be created if the user wants the symbol table, but not the listing
file. _def, _map and _sym (and in listing file) uses new tabulated space algorithm (to save file
storage).

- 1994-06-01  
"DS" has been removed from identifier function call table. DEFVARS() now executes a normal strcmp() to
check for the correct "DS" directive.

- 1994-05-15, V0.38:  
Z80RMF level 01 implemented: Infix expression string now also length prefixed. GetModuleSize() improved
to check if it is a proper 'Z80RMF01' file that is to be read. Library files now also checked to have
the 'Z80LMF01' header.

- 1994-05-13  
Bug fixed in link_modules(): Z80header were null-terminated beyond local array. This made created
peculiar crashes occasionally on the QL version. MSDOS-version now running perfectly. Releasing of
module & global data structures are now only released by Z80asm running on platforms other than the 
QL - the allocated data is released automatically when the job is killed.

- 1994-05-03, V0.37:  
Bug fixes in exprprsr_c, z80pass_c and modlink_c: All expression evaluation did a type casting of the
evaluated expression before the legal range were examined. This caused illegal ranges to be allowed in expressions.

- 1994-04-25, V0.36:  
enum flag introduced in expression record to identify whether the expression has been stored to
the object file or not. Label declarations are now always touched due to problems of forward referencing problems in
expressions and identifiers in object files. This had been implemented in an earlier version, but had apparently
been removed by accident - The drawback of this is that label declarations, that aren't used in a source file will
become redundant in the object file. However, this is rare and will not create more than 5% of additional size in
object files in worst case situations.

- 1994-04-19  
New window interface for QDOS / C68 version. config_h now defines the platform defintions (line feed size, etc.)

- 1994-04-06, V0.35:  
'-lib' changed to '-i', '-xlib' changed to '-x'. DEFINE algorithm didn't check if a symbol was already
defined.

- 1994-03-26  
DEFGROUP implemented to allow ENUM - alike symbols to be created just as easy as in C.

- 1994-03-25, V0.34:  
DEFVARS implemented to define variables and records in a more structured design. The old 'DS' renamed
to 'DEFS' (define storage). The following DS (define space) are available: ds.b (byte size) ds.w (word size) ds.p
(pointer size) ds.l (long word size)

- 1994-03-14, V0.33:  
Global definition file algorithm rewritten. The global definitions are now written continously after
completion of each module and NOT after linking. This eliminates the problem of not getting a def. file, if linking
couldn't be performed due to assembly errors.

- 1994-03-13  
Bug in ParseLine() fixed: If a label was encountered during non-interpretation of a source line, a syntax
error was reported. The should just have been skipped.

- 1994-03-08, V0.32:  
New keyword for library type declaration implemented: XLIB, define library routine address (also
declared as global). The type is stored as 'X' in the names declaration in object files.
The new type was needed to distinuish between names during output of a -g list, hence included library routine names
may not be in the list.

- 1994-03-04, V0.31:  
-lib and -xlib implemented. Major rewrite of module linking routines. New keyword implemented: 'LIB'
to declare external library routine (included during linking). New global variable for CURRENTMODULE (previously
used as the indirect pointers of the modulehdr structure. The global variable saves time and is more code efficient.

- 1994-02-25  
New type implemented for -D symbols. New keyword implemented: 'define' to execute the equivalent of -D on
the command line.

- 1994-02-23, V0.30:  
BINARY facility changed to used file name parameter as in INCLUDE. Bug in INCLUDE function fixed:
Did'nt set the EOL flag if end of line encoun- tered during reading of file name.
Expression evaluation altered: Expression are now evaluated completely, even though a single identifier is not known
(making the expression NOT EVALUABLE). The result of the evaluation is returned (but probably incorrect). This
allows specification of several -D symbols in an conditional assembly line, e.g.  "if MSDOS | UNIX", to be
evaluated to TRUE if just one symbol is defined (the expression is however detected as UNEVALUABLE).
-D symbols now saved separately in new STATIC tree structure, and copied into local symbols during assembly of each
module. This fixes the problem of -D used on multi-module-assembly (otherwise the -D symbol is removed after the
assembly of the first module). STATICs are first removed after the linking process.
The -D symbol is however stored into the object file if it were used in an expression (e.g. in an IF expression). It
should not, as it is of a different type of symbol than a CONSTANT or an ADDRESS. This must be fixed in a future
version.
On execution of the assembler, a unique -D symbol is created to identify the particular platform the assembler is
running in:  
'QDOS'  : Z80asm running on the QL and compatibles (ANSI C).  
'MSDOS' : Z80asm running on the IBM PC and compatibles (ANSI C).  
'LINUX' : Z80asm running on the LINUX/UNIX operating system (ANSI C).  
'Z88'   : Z80asm running on the Cambridge Z88 portable computer (handwritten machine code application).  

- 1994-02-19, V0.29:  
A help prompt is displayed if no arguments are defined.

- 1994-02-18  
Bugs in PushItem() and PopItem() fixed: Logic control were missing to handle a stack with no elements on
it!

- 1994-02-17  
Bug in EvalLogExpr() fixed: if syntax error occurred in a logical expression, a random integer were
returned, in stead of 0.

- 1994-02-14  
Bug in BINARY() fixed: binfile wasn't closed after read process.

- 1994-02-08  
Expression parsing optimised: Factor(), Term(), Expression() & Condition() - redundant pointer reference
level removed during parsing. Bug in ParseNumExpr() fixed: pfixhdr wasn't released if there wasn't room for
infixexpr area.

- 1994-01-31, V0.28:  
JP, CALL functions improved with better algorithm interface Bit manipulation functions improved (lack
of syntax check). '#IF', '#ELSE', '#ENDIF' changed to 'IF', 'ELSE', 'ENDIF' Listing file now also contains source
file line numbers The module code size is now displayed during verbose assembly.

1993
----

- 1993-12-18, V0.27:  
Line parsing bugs corrected in both normal and conditional assembly. EOL flag implemented to control
linefeed during recursive parsing.

- 1993-12-16, V0.26:  
Pass1 parsing now directly read by fgetc() instead of fgets(), since fgets() couldn't handle control
characters (tabs, etc.) in the assembler source file. Algorithms to parse expressions have been slightly changed,
since the underlying parsing have changed. The object file format has been changed in the expression section: Infix
expressions are now terminated with '\0' in stead of length identifier. This is necessary, since expression parsing
is also executed directly on the object file (expression). The listing file gets the complete line as usual
(directly from the source file).
Assembly optimised: Expressions are NOT evaluated if they contain address labels and no listing output is active (no
listing file or temporarily switched off).

- 1993-12-12, V0.25:  
Expression evaluation improved with logical NOT (using '!' in expressions) Some module pointer
algorithms rewritten.

- 1993-12-06, V0.24:  
All expressions may now be specified as logical expressions returning 1 for TRUE and 0 for FALSE.
logical operators are: =, <>, <, >, <= and >= .  
Conditional assembly implemented with #if, #else and #endif. Unlimited nesting of #if expressions allowed.  
pass1 algorithm optimized and rewritten to facilitate conditional assembly.

- 1993-09-06, V0.23:  
LSTON, LSTOFF directives implemented.

- 1993-09-02, V0.22:  
Binary operators AND, OR, XOR implemeneted in expression evalution. Constants are now globally
accessible, if defined with XDEF. Bug in Z80asm module code loading fixed: There was no check that code was
generated at all. Since the fptr_modcode was 0, the file pointer were set to the beginning of the file, and the
first two bytes were used as the length id (the 'Z80RMF' !) A check is now made to ensure that machine is available.  
Assembler function implemented, 'ASMPC' which returns the current assembler PC: This is can be useful during code
generation.

- 1993-08-31, V0.21:  
Bug in mapfile routine fixed: Trying to release the mapfile even if was empty. Symbols, constants and
expressions are now all treated as base type long. Name definitions are now also stored as long in the object file.
DEFL implemented to store 32bit signed integers in low byte - high byte sequense. FPP implemented to identify a
better interface to the OZ floating point package. Map file writes 'None.' if no map item are present.

- 1993-08-17, V0.19h:  
Symbol values are stored as signed long integers in object file. Symbol table (in listing file) also
altered to allow long integer display. Memory now no longer released after completed assembly in QDOS version.

- 1993-07-20, V0.19g:  
AVLTREE insertion optimized.

- 1993-07-06, V0.19f:  
Bug in TestAsmFile() fixed. The assembler now only reports 'file open error' if both source and object
file wasn't available.

- 1993-06-27  
file pointer read/write in object
standardised to low byte -> high byte order (V0.19d stored internal representation of long) this means that object
files are now portable to all computer platforms using the Z80 Module Assembler (Z88, QL, PC, ?)

- 1993-06-24, V0.19e:  
-r option at command line (define ORG) implemented. 

- 1993-06-22, V0.19d:  
ANSI source ported to Borland C++ V3.1 on the IBM PC. Many small inconsistencies removed to be 100%
compilable by Borland C++. ParseIdent() rewritten. A few bugs fixed in Z80asm_c module. 'relocfile' option flag
removed - object file is always created. -v option at command line (verbose assembly) implemented.

- 1993-06-09, V0.19c:  
Bugs in page reference algorithms fixed. Phase 2 of Z80 Cross Assembler Completed.

- 1993-05-21, V0.19b:  
List file & object file removed if errors encountered in module Error file feature implemented.

- 1993-05-14, V0.19:  
Date stamp control feature implemented.

- 1993-05-13, V0.18b:  
Modular assembly processing implemented.

- 1993-04-01, V0.16:  
Allocation & search of symbols restructured into AVL tree.

- 1993-03-24, V0.15c:  
PrsIdent() rewritten. Uses standard ANSI C bsearch function to locate Z80 identifier. (array of
structure containing the identifier and a pointer to a function)

- 1993-03-16, V0.15b:  
Bug in Expression evaluation algorithms fixed: Allocation/Deallocation of memory in ParseNumExpr() and
EvalExpr() rewritten.

1992
----

- 1992-11-26, V0.15:  
Listfile Page Number References included in symbol table output. BINARY directive implemented. Phase 1
of Z80 Cross Assembler Completed.

- 1992-11-23, V0.14:  
Sorted symbol table output in listing file - output'ed only if no errors ocurred. The assembler no
longer distinguishes upper and lower case identifiers. The source can now be written any mixture of upper and lower
case letters.

- 1992-11-15, V0.13:  
INCLUDE directive implemented. Improvement on general error handling.

- 1992-11-09, V0.12:  
List file layout finished (header, datestamp, etc.)

- 1992-11-08, V0.011:  
Removal of parsing information after pass 2. Parsing error system improved.

- 1992-11-05, V0.010:  
Parsing & code generation of all Z80 instructions. Command line argument implemented. Simple listing
file implemented.

- 1992-02-10, V0.008:  
Parsing of numerical expressions rewritten. New operators implemented: /, %, * Expressions now stored
in linked lists as postfix expressions. Getident() -> Getsym() (also modified to return an enumerated symbol)
Numexpression() removed. 28.10.92  V0.009 Many changes and implementations of Z80 instructions. More Source file
modules.

- 1992-09-17, V0.007:  
Ported to C68 - the Public Domain C compiler for QL. Improved with ANSI C prototyping and function
parameters. Minor bugs detected.

- 1992-05-01, V0.006:  
Hashtable array, 'SymPtrIndex', and relative jump address label array, 'JR_address', now created at
runtime. This saves 12K of program space!
Reporterror() implemented in 'Parseline_c' - all return error in various functions are now standardised.

- 1992-03-03, V0.005:  
Algorithms for converting ASCII symbols into integer values implemented:
Symbol storing algorithms now changed to infinite numbers of symbol allocation (as long as memory are available). Also,
it is now allowed to have identifiers with dynamic length's though only a maximum of 254 chars (maximum length of
line minus a dot to indicate a label definition).

- 1992-02-25, V0.004:  
Algortihms for symbol storing & lookup, using hash table and linked lists:

1991
----

- 1991-09-13, V0.003:  
Getidentifier() renamed to Getident().
Main body of parse_file() finished - all parsing of Z80 instructions and assembler directives implemented. 
functions now split up into modules:

- 1991-08-31, V0.002:  
Work on Pass 1 - Z80 commands.

- 1991-08-28, V0.001:  
GetIdentifier tested - working.

- 1991-08-26, V0.000:  
Work on Draft version of GetIdentifier started.
Main Source file - definition of global identifiers etc.

