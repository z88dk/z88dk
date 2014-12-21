/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/hist.c,v 1.129 2014-12-21 17:20:54 pauloscustodio Exp $
*/

/*
 * Z80 Module Assembler       - C version, by Gunther Strube - InterLogic 1992-1999
 *
 * converted from QL SuperBASIC version 0.956. Initially ported to Lattice C then C68 on QDOS.
 */

/*
* $Log: hist.c,v $
* Revision 1.129  2014-12-21 17:20:54  pauloscustodio
* New ORG -1 to a section to be written to a new binary file, even if
* the address is consecutive with the previous section.
*
* Revision 1.128  2014/12/21 02:24:42  pauloscustodio
* New option --split-bin: Create one binary file per section
*
* Revision 1.127  2014/12/19 21:21:08  pauloscustodio
* IFNDEF / ELSE / ENDIF implemented
*
* Revision 1.126  2014/12/19 00:35:07  pauloscustodio
* IFDEF / ELSE / ENDIF implemented
*
* Revision 1.125  2014/12/13 00:50:55  pauloscustodio
* Implemented infrastructure to do parsing based on a RAGEL state machine,
* and to fall back to the original parser on error. Implemented the first
* two simple opcodes (NOP and HALT) as a concept check.
*
* Revision 1.124  2014/12/04 23:38:55  pauloscustodio
* No longer needs to backtrack during parsing, remove ScanGetPos() and
* ScanSetPos().
*
* Revision 1.123  2014/12/04 23:30:19  pauloscustodio
* Add lexer tokens for registers, CPU flags and DEFVARS size specifiers,
* simplifying the parser. As a side effect register names can no longer
* be used as labels, but this would be confusing anyway.
*
* Revision 1.122  2014/10/03 22:57:50  pauloscustodio
* Remove option -c (split in 16k blocks) - no longer necessary with
* split binary files for each section with a defined ORG.
*
* Revision 1.121  2014/09/28 17:37:14  pauloscustodio
* Split binary files for each section with a defined ORG.
* Object file format changed to version 08, to include ORG address per section.
*
* Revision 1.120  2014/09/11 22:28:35  pauloscustodio
* DEFC with expressions; expressions containing external symbols are stored in the object file
* and evaluated at link time.
* e.g.
*
* PUBLIC alias
* EXTERN func
* DEFC alias = func
*
* - Object file format changed to version 07, to include DEFC symbols that
* are defined as an expression using other symbols and are computed at link
* time, after all addresses are allocated.
* - Symbols are now linked into expressions so that the symbol value
* is used during expression eval. Before the symbol value was frozen
* during expression parse.
* - Symbols cannot be deleted and re-created when moving from local to global
* table, to keep references in expressions pointing to allocated memory.
* - Symbols need to have a new category: computed, actual value not
* yet known.
* - ASMPC needs to be recomputed at pass2 and link time.
*
* Revision 1.119  2014/09/01 23:37:32  pauloscustodio
* One step towards DEFC with expressions:
* symbols cannot be deleted and re-created when moving from local to global
* table, to keep references in expressions pointing to allocated memory.
*
* Revision 1.118  2014/07/14 08:43:32  pauloscustodio
* Remove SYM_DEFINE, not used.
*
* Revision 1.117  2014/07/06 22:48:53  pauloscustodio
* Separate symbol type from the bit mask stored in Symbol and Expr,
* to be able to identify constant values, values that need to be
* relocated and values that need to be computed at the end of the
* link phase (for DEFC with expressions).
*
* Revision 1.116  2014/06/30 22:29:36  pauloscustodio
* Separate expression type from expression range - new range_t enum
* type for ranges and new range attribute in Expr.
*
* Revision 1.115  2014/06/29 22:25:14  pauloscustodio
* Object file format changed to version 06, to include DEFC symbols that
* are defined as an expression using other symbols and are computed at link
* time, after all addresses are allocated.
*
* DEFC with expressions not yet enabled, need changes in the symbol table first.
*
* Two problems need to be solved before DEFC with expressions can be
* enabled:
* 1) symbols need to be linked into expressions so that the symbol value
* is used during expression eval. Today the symbol value is frozen
* during expression parse.
* 2) symbols need to have a new category: computed, actual value not
* yet known.
*
* Revision 1.114  2014/06/27 23:31:52  pauloscustodio
* Write empty sections to the object file, to allow the user to define
* the sections sequence in the final binary by writing a list of empty
* sections at the top of the source file, even if the source does not
* assembly any data for some of the sections, e.g.:
* 	section code
* 	section data
* 	section bss
*
* Revision 1.113  2014/06/26 21:33:24  pauloscustodio
* Bugfix in sections: wrong address computation when symbols declared
* public in a different section that the definition.
* If a symbol was defined in the "code" section, and then declared public
* in a "data" section, it was stored in the object file as if it was defined
* in "data", causing wrong address computations at link time.
*
* Revision 1.112  2014/06/23 23:40:08  pauloscustodio
* SECTION keyword parsed to change to a new section.
*
* Revision 1.111  2014/06/23 22:27:09  pauloscustodio
* Added support to sections in the object code area of the object file.
* Written ORG to object file as a 32-bit integer to allow ORG 0xFFFF.
*
* Revision 1.110  2014/06/21 02:15:43  pauloscustodio
* Modified the address computations in pass 2 and during linking and
* the generation of the binary image to support the sections defined
* in the codearea.
*
* Revision 1.109  2014/06/13 16:00:45  pauloscustodio
* Extended codearea.c to support different sections of code.
*
* Revision 1.108  2014/06/09 13:15:26  pauloscustodio
* Int and UInt types
*
* Revision 1.107  2014/06/03 22:53:14  pauloscustodio
* Do not sort symbols before writing to object file. Not needed and
* wastes time.
*
* Revision 1.106  2014/06/02 22:29:13  pauloscustodio
* Write object file in one go at the end of pass 2, instead of writing
* parts during pass 1 assembly. This allows the object file format to be
* changed more easily, to allow sections in a near future.
* Remove global variable objfile and CloseFiles().
*
* Revision 1.105  2014/06/01 22:16:50  pauloscustodio
* Write expressions to object file only in pass 2, to remove dupplicate code
* and allow simplification of object file writing code. All expression
* error messages are now output only during pass 2.
*
* Revision 1.104  2014/05/29 00:19:37  pauloscustodio
* CH_0025: Link-time expression evaluation errors show source filename and line number
* Object file format changed to version 04, to include the source file
* location of expressions in order to give meaningful link-time error messages.
*
* Revision 1.103  2014/05/25 12:55:03  pauloscustodio
* Link expressions to the section they refer to.
*
* Revision 1.102  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.101  2014/05/20 22:26:29  pauloscustodio
* BUG_0051: DEFC and DEFVARS constants do not appear in map file
* Constants defined with DEFC and DEFVARS, and declared PUBLIC are not
* written to the map file.
* Logic to select symbols for map and def files was wrong.
*
* Revision 1.100  2014/05/17 22:42:25  pauloscustodio
* Move load_module_object() that loads object file size when assembling
* with -d option to objfile.c. Change objfile API.
*
* Revision 1.99  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.98  2014/05/17 10:57:45  pauloscustodio
* Parse argv generates list of files that can be iterated by assembler,
* linker and librarian.
*
* Revision 1.97  2014/05/06 22:17:37  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.96  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.95  2014/04/26 09:25:32  pauloscustodio
* BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
* When a library is built with -d, and the total size of the loaded
* modules is more than 64K, z80asm fails with "max. code size reached".
*
* Revision 1.94  2014/04/26 08:12:04  pauloscustodio
* BUG_0049: Making a library with -d and 512 object files fails - Too many open files
* Error caused by z80asm not closing the intermediate object files, when
* assembling with -d.
*
* Revision 1.93  2014/04/23 22:07:12  pauloscustodio
* Too many open files was caused by all modules loaded during assembly keeping the FILE* open.
*
* Revision 1.92  2014/04/22 23:55:18  pauloscustodio
* As inc_PC() is no longer needed, append_opcode() no longer makes sense.
* Removed append_opcode() and created a new helper append_2bytes().
*
* Revision 1.91  2014/04/22 23:32:42  pauloscustodio
* Release 2.2.0 with major fixes:
*
* - Object file format changed to version 03, to include address of start
* of the opcode of each expression stored in the object file, to allow
* ASMPC to refer to the start of the opcode instead of the patch pointer.
* This solves long standing BUG_0011 and BUG_0048.
*
* - ASMPC no longer stored in the symbol table and evaluated as a separate
* token, to allow expressions including ASMPC to be relocated. This solves
* long standing and never detected BUG_0047.
*
* - Handling ASMPC during assembly simplified - no need to call inc_PC() on
* every assembled instruction, no need to store list of JRPC addresses as
* ASMPC is now stored in the expression.
*
* BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
* ASMPC is computed on zero-base address of the code section and expressions
* including ASMPC are not relocated at link time.
* "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
* The expression ASMPC+3 is not marked as relocateable, and the resulting
* code only works when linked at address 0.
*
* BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
* In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
* of instruction-address.
*
* BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
* Bug only happens with forward references to relative addresses in expressions.
* See example from zx48.asm ROM image in t/BUG_0011.t test file.
* Need to change object file format to correct - need patchptr and address of instruction start.
*
* Revision 1.90  2014/04/19 14:57:37  pauloscustodio
* BUG_0046: Expressions stored in object file with wrong values in MacOS
* Symthom: ZERO+2*[1+2*(1+140709214577656)] stored instead of ZERO+2*[1+2*(1+2)]
* Problem caused by non-portable way of repeating a call to vsnprintf without
* calling va_start in between. The repeated call is necessary when the
* dynamically allocated string needs to grow to fit the value to be stored.
*
* Revision 1.89  2014/04/18 17:46:18  pauloscustodio
* - Change struct expr to Expr class, use CLASS_LIST instead of linked list
*   manipulating.
* - Factor parsing and evaluating contants.
* - Factor symbol-not-defined error during expression evaluation.
* - Store module name in strpool instead of xstrdup/xfree.
*
* Revision 1.88  2014/04/13 11:54:01  pauloscustodio
* CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
* Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
* Remove 'X' scope for symbols in object files used before for XLIB -
* all PUBLIC symbols have scope 'G'.
* Remove SDCC hack on object files trating XLIB and XDEF the same.
* Created a warning to say XDEF et.al. are deprecated, but for the
* momment keep it commented.
*
* Revision 1.87  2014/04/06 23:32:24  pauloscustodio
* .
*
* Revision 1.86  2014/04/05 23:36:11  pauloscustodio
* CH_0024: Case-preserving, case-insensitive symbols
* Symbols no longer converted to upper-case, but still case-insensitive
* searched. Warning when a symbol is used with different case than
* defined. Intermidiate stage before making z80asm case-sensitive, to
* be more C-code friendly.
*
* Revision 1.85  2014/04/03 21:31:13  pauloscustodio
* BUG_0045: -D did not accept symbols starting with '_':
* (reported and fixed by alvin_albrecht@hotmail.com)
* Added test code.
*
* Revision 1.84  2014/03/30 10:42:08  pauloscustodio
* CH_0023: Accept C-like escape sequences in character constants and strings
* Accepts \a, \b, \e (0x1B), \f, \n, \r, \t, \v, \{any character}, \{octal}, \x{hexadecimal}, allows \0 within the string.
* Existing code may have to be modified, e.g. defb '\' --> defb '\\'
*
* Revision 1.83  2014/03/29 01:46:14  pauloscustodio
* version
*
* Revision 1.82  2014/03/29 01:27:33  pauloscustodio
* version
*
* Revision 1.81  2014/03/29 01:20:30  pauloscustodio
* Accept both "ex af,af" and "ex af,af'"
*
* Revision 1.80  2014/03/29 00:33:28  pauloscustodio
* BUG_0044: binary constants with more than 8 bits not accepted
* CH_0022: Added syntax to define binary numbers as bitmaps
* Replaced tokenizer with Ragel based scanner.
* Simplified scanning code by using ragel instead of hand-built scanner
* and tokenizer.
* Removed 'D' suffix to signal decimal number.
* Parse AF' correctly.
* Decimal numbers expressed as sequence of digits, e.g. 1234.
* Hexadecimal numbers either prefixed with '0x' or '$' or suffixed with 'H',
* in which case they need to start with a digit, or start with a zero,
* e.g. 0xFF, $ff, 0FFh.
* Binary numbers either prefixed with '0b' or '@', or suffixed with 'B',
* e.g. 0b10101, @10101, 10101b.
*
* Revision 1.79  2014/03/06 00:29:01  pauloscustodio
* spelling
*
* Revision 1.78  2014/03/06 00:18:43  pauloscustodio
* BUG_0043: buffer overflow on constants longer than 128 chars in object file
* z80asm crashed when the expression to be stored in the obejct file was
* longer than the maximum allocated size (128). Changed to dynamic string.
*
* Revision 1.76  2014/03/03 13:27:07  pauloscustodio
* Rename symbol type constants
*
* Revision 1.75  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.74  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.73  2014/02/23 18:48:16  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, ?:
* Handle C-like operators ==, !=, &&, || and ?:.
* Simplify expression parser by handling composed tokens in lexer.
*
* Revision 1.72  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.71  2014/02/18 22:59:06  pauloscustodio
* BUG_0040: Detect and report division by zero instead of crashing
* BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
*
* Revision 1.70  2014/02/08 18:30:49  pauloscustodio
* lib/srcfile.c to read source files and handle recursive includes,
* used to read @lists, removed opts.files;
* model.c to hold global data model
*
* Revision 1.69  2014/01/29 22:40:52  pauloscustodio
* Mechanism for atomic file write - open a temp file for writing on
* xfopen_atomic(), close and rename to final name on xfclose().
* temp_filename() to generate a temporary file name that is
* deleted atexit.
*
* Revision 1.68  2014/01/15 00:01:40  pauloscustodio
* Decouple file.c from errors.c by adding a call-back mechanism in file for
* fatal errors, setup by errors_init()
*
* Revision 1.67  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.66  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.65  2014/01/10 00:15:26  pauloscustodio
* Use Str instead of glib, List instead of GSList.
* Use init.h mechanism, no need for main() calling init_scan.
* glib dependency removed from code and Makefile
*
* Revision 1.64  2014/01/09 23:26:24  pauloscustodio
* Use init.h mechanism, no need for main() calling init_codearea
*
* Revision 1.63  2014/01/09 23:13:03  pauloscustodio
* Use init.h mechanism, no need for main() calling init_options.
* Use Str instead of glib.
*
* Revision 1.62  2014/01/05 23:20:39  pauloscustodio
* List, StrHash classlist and classhash receive the address of the container
* object in all functions that add items to the container, and create the
* container on first use. This allows a container to be staticaly
* initialized with NULL and instantiated on first push/unshift/set.
* Add count attribute to StrHash, classhash to count elements in container.
* Add free_data attribute in StrHash to register a free fucntion to delete
* the data container when the hash is removed or a key is overwritten.
*
* Revision 1.61  2014/01/02 23:33:11  pauloscustodio
* Unify interface of classlist and list.
*
* Revision 1.60  2014/01/02 17:18:45  pauloscustodio
* StrList removed, replaced by List
*
* Revision 1.59  2014/01/01 21:23:48  pauloscustodio
* Move generic file utility functions to lib/fileutil.c
*
* Revision 1.58  2013/12/30 02:07:32  pauloscustodio
* Version 2.1.1
*
* Revision 1.57  2013/12/30 02:05:32  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
*
* Revision 1.56  2013/12/25 16:29:34  pauloscustodio
* classring deleted, not used
*
* Revision 1.55  2013/12/15 23:31:04  pauloscustodio
* Replace code-generation for init() functions by macros in init.h
* to help define init() and fini() functions per module.
* Code generation complicates maintenance, as all the modules with init()
* functions are coupled together, and it may not be clear how the init()
* module appears.
*
* Revision 1.54  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.53  2013/11/26 22:59:08  pauloscustodio
* Version 2.0.0: new C-like expression syntax, incompatible object file format with previous version
*
* Revision 1.52  2013/11/26 22:46:03  pauloscustodio
* Version 1.2.10
*
* Revision 1.51  2013/10/05 13:45:19  pauloscustodio
* Version 1.2.9
*
* Revision 1.50  2013/09/12 00:10:02  pauloscustodio
* Create xfree() macro that NULLs the pointer after free, required
* by z80asm to find out if a pointer was already freed.
*
* Revision 1.49  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.48  2013/08/30 21:50:43  pauloscustodio
* By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
* as an identifier reserved by the C standard for implementation-defined behaviour
* starting with two underscores.
*
* Revision 1.47  2013/08/30 01:06:08  pauloscustodio
* New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX is not defined. Keeps old
* behaviour under -D__LEGACY_Z80ASM_SYNTAX (defined in legacy.h)
*
* BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
* - Expressions now use more standard C-like operators
* - Object and library files changed signature to
*   "Z80RMF02", "Z80LMF02", to avoid usage of old
*   object files with expressions inside in the old format
*
* Detail:
* - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
* - Power:                        changed from '^' to '**'; '^' will be XOR
* - XOR:                          changed from ':' to '^';
* - AND:                          changed from '~' to '&';  '~' will be NOT
* - NOT:                          '~' added as binary not
*
* Revision 1.46  2013/08/26 21:49:39  pauloscustodio
* Bug report 2013-07-27 10:50:27 by rkd77 : compile with -Wformat -Werror=format-security
*
* Revision 1.45  2013/08/26 21:18:03  pauloscustodio
* Version 1.2.4
*
* Revision 1.44  2013/06/15 22:10:01  pauloscustodio
* BUG_0037 : Symbol already defined error when symbol used in IF expression
*
* Revision 1.43  2013/06/14 23:49:15  pauloscustodio
* Version 1.2.2
*
* Revision 1.42  2013/06/10 23:11:33  pauloscustodio
* CH_0023 : Remove notdecl_tab
*
* Revision 1.41  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMSIZE, ASMTAIL
*
* Revision 1.40  2013/06/01 01:26:26  pauloscustodio
* Version 1.2.0
*
* Revision 1.39  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
*
* Revision 1.38  2013/02/16 09:46:55  pauloscustodio
* BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode
*
* Revision 1.37  2013/02/12 00:59:14  pauloscustodio
* Version 1.1.21
*
* Revision 1.36  2013/01/20 13:45:49  pauloscustodio
* Version 1.1.20
*
* Revision 1.35  2012/11/03 17:41:11  pauloscustodio
* Version 1.1.19
*
* Revision 1.34  2012/11/01 23:21:49  pauloscustodio
* Version 1.1.18
*
* Revision 1.33  2012/06/05 22:24:47  pauloscustodio
* BUG_0020 : Segmentation fault in ParseIdent for symbol not found with interpret OFF
*
* Revision 1.32  2012/05/30 22:06:48  pauloscustodio
* BUG_0019 : z80asm closes a closed file handle, crash in Linux
*
* Revision 1.31  2012/05/29 21:03:39  pauloscustodio
* Version 1.1.16
*
* Revision 1.30  2012/05/26 18:56:02  pauloscustodio
* Version 1.1.15
*
* Revision 1.29  2012/05/22 20:37:47  pauloscustodio
* Version 1.1.14
*
* Revision 1.28  2012/05/12 17:15:57  pauloscustodio
* Version 1.1.13
*
* Revision 1.27  2012/01/12 18:53:58  pauloscustodio
* comment
*
* Revision 1.26  2011/10/14 15:02:39  pauloscustodio
* Version 1.1.12
*
* Revision 1.25  2011/10/07 17:56:02  pauloscustodio
* Version 1.1.11
*
* Revision 1.24  2011/09/30 10:30:06  pauloscustodio
* Version 1.1.10
*
* Revision 1.23  2011/09/29 21:26:43  pauloscustodio
* Version 1.1.9
*
* Revision 1.22  2011/08/19 19:22:28  pauloscustodio
* Version 1.1.8
*
* Revision 1.21  2011/08/14 19:50:31  pauloscustodio
* Version 1.1.7
*
* Revision 1.20  2011/08/05 20:26:42  pauloscustodio
* Version 1.1.6
*
* Revision 1.19  2011/07/18 00:54:01  pauloscustodio
* Version 1.1.5
*
* Revision 1.18  2011/07/14 23:49:55  pauloscustodio
* 15.07.2011 [1.1.4]
*
* Revision 1.17  2011/07/14 01:36:17  pauloscustodio
* Version 1.1.3
*
* Revision 1.16  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
* Revision 1.15  2011/07/11 16:27:44  pauloscustodio
* Version 1.1.2
*
* Revision 1.14  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
*
* Revision 1.13  2011/07/09 17:40:37  pauloscustodio
* fix version 1.1.1 date
*
* Revision 1.12  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into history
*
* Revision 1.11  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
*
* Revision 1.10  2011/07/09 01:08:47  pauloscustodio
* Moved version strings to hist.c, created hist.h, for easy maintenance.
*
* Revision 1.9  2002/04/22 14:45:51  stefano
* Removed the SLL L undocumented instructions from the Graph library.
* NEW startup=2 mode for the ZX81 (SLOW mode... hoping we'll make it work in the future).
* MS Visual C compiler related fixes
* -IXIY option on Z80ASM to swap the IX and IY registers
*
* Revision 1.8  2002/01/18 21:12:17  dom
* 0x prefix allowed for hex constants
*
* Revision 1.7  2002/01/18 16:53:13  dom
* added 'd' and 'b' identifiers for constants - decimal and binary
* respectively.
*
* Revision 1.6  2002/01/18 16:30:19  dom
* *** empty log message ***
*
* Revision 1.5  2001/06/27 08:53:29  dom
* Added a second parameter to defs to indicate what the filler byte should be
*
* Revision 1.4  2001/03/21 16:34:01  dom
* Added changes to allow labels to end in ':' and the prefix '.' isn't
* necessarily needed..this isn't guaranteed to be perfect so let me know
* of any problems and drop back to 1.0.18
*
* Revision 1.3  2001/02/28 18:19:24  dom
* Fixed size of Z80ident table <grrr>
*
* Revision 1.2  2001/01/23 10:00:09  dom
* Changes by x1cygnus:
*
* just added a harcoded macro Invoke, similar to callpkg except that the
* instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
* the parameter -plus is specified on the command line.
*
* Changes by dom:
* Added in a rudimentary default directory set up (Defined at compile time)
* a bit kludgy and not very nice!
*
* Revision 1.1  2000/07/04 15:33:30  dom
* branches:  1.1.1;
* Initial revision
*
* Revision 1.1.1.1  2000/07/04 15:33:30  dom
* First import of z88dk into the sourceforge system <gulp>
*
*/

/*
Main Source file - definition of global identifiers etc.

26.08.91, V0.000:
Work on Draft version of GetIdentifier started.

28.08.91, V0.001:
GetIdentifier tested - working.

31.08.91, V0.002:
Work on Pass 1 - Z80 commands.

13.09.91, V0.003:
Getidentifier() renamed to Getident().
Main body of Z80pass1() finished - all parsing of Z80 instructions and assembler directives implemented. 
functions now split up into modules:

25.02.92, V0.004:
Algortihms for symbol storing & lookup, using hash table and linked lists:

03.03.92, V0.005:
Algorithms for converting ASCII symbols into integer values implemented:
Symbol storing algorithms now changed to infinite numbers of symbol allocation (as long as memory are available). Also,
it is now allowed to have identifiers with dynamic length's though only a maximum of 254 chars (maximum length of
line minus a dot to indicate a label definition).

01.05.92, V0.006:
Hashtable array, 'SymPtrIndex', and relative jump address label array, 'JR_address', now created at
runtime. This saves 12K of program space!
Reporterror() implemented in 'Parseline_c' - all return error in various functions are now standardised.

17.09.92, V0.007:
Ported to C68 - the Public Domain C compiler for QL. Improved with ANSI C prototyping and function
parameters. Minor bugs detected.

10.02.92, V0.008:
Parsing of numerical expressions rewritten. New operators implemented: /, %, * Expressions now stored
in linked lists as postfix expressions. Getident() -> Getsym() (also modified to return an enumerated symbol)
Numexpression() removed. 28.10.92  V0.009 Many changes and implementations of Z80 instructions. More Source file
modules.

05.11.92, V0.010:
Parsing & code generation of all Z80 instructions. Command line argument implemented. Simple listing
file implemented.

08.11.92, V0.011:
Removal of parsing information after pass 2. Parsing error system improved.

09.11.92, V0.12:
List file layout finished (header, datestamp, etc.)

15.11.92, V0.13:
INCLUDE directive implemented. Improvement on general error handling.

23.11.92, V0.14:
Sorted symbol table output in listing file - output'ed only if no errors ocurred. The assembler no
longer distinguishes upper and lower case identifiers. The source can now be written any mixture of upper and lower
case letters.

26.11.92, V0.15:
Listfile Page Number References included in symbol table output. BINARY directive implemented. Phase 1
of Z80 Cross Assembler Completed.

16.03.93, V0.15b:
Bug in Expression evaluation algorithms fixed: Allocation/Deallocation of memory in ParseNumExpr() and
EvalExpr() rewritten.

24.03.93, V0.15c:
PrsIdent() rewritten. Uses standard ANSI C bsearch function to locate Z80 identifier. (array of
structure containing the identifier and a pointer to a function)

01.04.93, V0.16:
Allocation & search of symbols restructured into AVL tree.

13.05.93, V0.18b:
Modular assembly processing implemented.

14.05.93, V0.19:
Date stamp control feature implemented.

21.05.93, V0.19b:
List file & object file removed if errors encountered in module Error file feature implemented.

09.06.93, V0.19c:
Bugs in page reference algorithms fixed. Phase 2 of Z80 Cross Assembler Completed.

22.06.93, V0.19d:
ANSI source ported to Borland C++ V3.1 on the IBM PC. Many small inconsistencies removed to be 100%
compilable by Borland C++. ParseIdent() rewritten. A few bugs fixed in Z80asm_c module. 'relocfile' option flag
removed - object file is always created. -v option at command line (verbose assembly) implemented.

24.06.93, V0.19e:
-r option at command line (define ORG) implemented. 27.06.93 file pointer read/write in object
standardised to low byte -> high byte order (V0.19d stored internal representation of long) this means that object
files are now portable to all computer platforms using the Z80 Module Assembler (Z88, QL, PC, ?)

06.07.93, V0.19f:
Bug in TestAsmFile() fixed. The assembler now only reports 'file open error' if both source and object
file wasn't available.

20.07.93, V0.19g:
AVLTREE insertion optimized.

17.08.93, V0.19h:
Symbol values are stored as signed long integers in object file. Symbol table (in listing file) also
altered to allow long integer display. Memory now no longer released after completed assembly in QDOS version.

31.08.93, V0.21:
Bug in mapfile routine fixed: Trying to release the mapfile even if was empty. Symbols, constants and
expressions are now all treated as base type long. Name definitions are now also stored as long in the object file.
DEFL implemented to store 32bit signed integers in low byte - high byte sequense. FPP implemented to identify a
better interface to the OZ floating point package. Map file writes 'None.' if no map item are present.

02.09.93, V0.22:
Binary operators AND, OR, XOR implemeneted in expression evalution. Constants are now globally
accessible, if defined with XDEF. Bug in Z80asm module code loading fixed: There was no check that code was
generated at all. Since the fptr_modcode was 0, the file pointer were set to the beginning of the file, and the
first two bytes were used as the length id (the 'Z80RMF' !) A check is now made to ensure that machine is available.
Assembler function implemented, 'ASMPC' which returns the current assembler PC: This is can be useful during code
generation.

06.09.93, V0.23:
LSTON, LSTOFF directives implemented.

06.12.93, V0.24:
All expressions may now be specified as logical expressions returning 1 for TRUE and 0 for FALSE.
logical operators are: =, <>, <, >, <= and >= .
Conditional assembly implemented with #if, #else and #endif. Unlimited nesting of #if expressions allowed.
pass1 algorithm optimized and rewritten to facilitate conditional assembly.

12.12.93, V0.25:
Expression evaluation improved with logical NOT (using '!' in expressions) Some module pointer
algorithms rewritten.

16.12.93, V0.26:
Pass1 parsing now directly read by fgetc() instead of fgets(), since fgets() couldn't handle control
characters (tabs, etc.) in the assembler source file. Algorithms to parse expressions have been slightly changed,
since the underlying parsing have changed. The object file format has been changed in the expression section: Infix
expressions are now terminated with '\0' in stead of length identifier. This is necessary, since expression parsing
is also executed directly on the object file (expression). The listing file gets the complete line as usual
(directly from the source file).
Assembly optimised: Expressions are NOT evaluated if they contain address labels and no listing output is active (no
listing file or temporarily switched off).

18.12.93, V0.27:
Line parsing bugs corrected in both normal and conditional assembly. EOL flag implemented to control
linefeed during recursive parsing.

31.01.94, V0.28:
JP, CALL functions improved with better algorithm interface Bit manipulation functions improved (lack
of syntax check). '#IF', '#ELSE', '#ENDIF' changed to 'IF', 'ELSE', 'ENDIF' Listing file now also contains source
file line numbers The module code size is now displayed during verbose assembly.
08.02.94  Expression parsing optimised: Factor(), Term(), Expression() & Condition() - redundant pointer reference
level removed during parsing. Bug in ParseNumExpr() fixed: pfixhdr wasn't released if there wasn't room for
infixexpr area.
14.02.94  Bug in BINARY() fixed: binfile wasn't closed after read process.
17.02.94  Bug in EvalLogExpr() fixed: if syntax error occurred in a logical expression, a random integer were
returned, in stead of 0.
18.02.94  Bugs in PushItem() and PopItem() fixed: Logic control were missing to handle a stack with no elements on
it!

19.02.94, V0.29:
A help prompt is displayed if no arguments are defined.

23.02.94, V0.30:
BINARY facility changed to used file name parameter as in INCLUDE. Bug in INCLUDE function fixed:
Did'nt set the EOL flag if end of line encoun- tered during reading of file name.
Expression evaluation altered: Expression are now evaluated completely, even though a single identifier is not known
(making the expression NOT EVALUABLE). The result of the evaluation is returned (but probably incorrect). This
allowes specification of several -D symbols in an conditional assembly line, e.g.  "if MSDOS | UNIX", to be
evaluated to TRUE if just one symbol is defined (the expression is however detected as UNEVALUABLE).
-D symbols now saved separately in new STATIC tree structure, and copied into local symbols during assembly of each
module. This fixes the problem of -D used on multi-module-assembly (otherwise the -D symbol is removed after the
assembly of the first module). STATICs are first removed after the linking process.
The -D symbol is however stored into the object file if it were used in an expression (e.g. in an IF expression). It
should not, as it is of a different type of symbol than a CONSTANT or an ADDRESS. This must be fixed in a future
version.
On execution of the assembler, a unique -D symbol is created to identify the particular platform the assembler is
running in:  'QDOS'  : Z80asm running on the QL and compatibles (ANSI C).
             'MSDOS' : Z80asm running on the IBM PC and compatibles (ANSI C).
             'LINUX' : Z80asm running on the LINUX/UNIX operating system (ANSI C).
             'Z88'   : Z80asm running on the Cambridge Z88 portable computer (handwritten machine code application).

25.02.94  New typ implemented for -D symbols. New keyword implemented: 'define' to execute the equivalent of -D on
the command line.

04.03.94, V0.31:
-lib and -xlib implemented. Major rewrite of module linking routines. New keyword implemented: 'LIB'
to declare external library routine (included during linking). New global variable for CURRENTMODULE (previously
used as the indirect pointers of the modulehdr structure. The global variable saves time and is more code efficient.

08.04.94, V0.32:
New keyword for library type declaration implemented: XLIB, define library routine address (also
declared as global). The type is stored as 'X' in the names declaration in object files.
The new type was needed to distinuish between names during output of a -g list, hence included library routine names
may not be in the list.
13.03.94  Bug in ParseLine() fixed: If a label was encountered during non-interpretation of a source line, a syntax
error was reported. The should just have been skipped.

14.03.94, V0.33:
Global definition file algorithm rewritten. The global definitions are now written continously after
completion of each module and NOT after linking. This eliminates the problem of not getting a def. file, if linking
couldn't be performed due to assembly errors.

25.03.94, V0.34:
DEFVARS implemented to define variables and records in a more structured design. The old 'DS' renamed
to 'DEFS' (define storage). The following DS (define space) are available: ds.b (byte size) ds.w (word size) ds.p
(pointer size) ds.l (long word size)
26.03.94  DEFGROUP implemented to allow ENUM - alike symbols to be created just as easy as in C.
06.04.94, V0.35: '-lib' changed to '-i', '-xlib' changed to '-x'. DEFINE algorithm didn't check if a symbol was already
defined.
19.04.94  New window interface for QDOS / C68 version. config_h now defines the platform defintions (line feed size,
etc.)

25.04.94, V0.36:
enum flag introduced in expression record to identify whether the expression has been stored to
the object file or not. Label declarations are now always touched due to problems of forward referencing problems in
expressions and identifiers in object files. This had been implemented in an earlier version, but had apparently
been removed by accident - The drawback of this is that label declarations, that aren't used in a source file will
become redundant in the object file. However, this is rare and will not create more than 5% of additional size in
object files in worst case situations.

03.05.94, V0.37:
Bug fixes in exprprsr_c, z80pass_c and modlink_c: All expression evaluation did a type casting of the
evaluated expression before the legal range were examined. This caused illegal ranges to be allowed in expressions.
13.05.94  Bug fixed in link_modules(): Z80header were null-terminated beyond local array. This made created peculiar
crashes occasionally on the QL version. MSDOS-version now running perfectly. Releasing of module & global data
structures are now only released by Z80asm running on platforms other than the QL - the allocated data is released
automatically when the job is killed.

15.05.94, V0.38:
Z80RMF level 01 implemented: Infix expression string now also length prefixed. GetModuleSize() improved
to check if it is a proper 'Z80RMF01' file that is to be read. Library files now also checked to have the 'Z80LMF01'
header.
01.06.94  "DS" has been removed from identifier function call table. DEFVARS() now executes a normal strcmp() to
check for the correct "DS" directive.

07.06.94, V0.39:
Symbol file implemented. This will be created if the user wants the symbol table, but not the listing
file. _def, _map and _sym (and in listing file) uses new tabulated space algorithm (to save file storage).
15.06.94  Internal improvement of module & library linking routines.

17.06.94, V0.40:
DEFVARS origin parameter may now be an expression (with no forward references) Default tabulator
distance now set to 8, column width is 4 times t. distance.

16.09.94, V0.41:
Size specifier in DEFVARS variable offset may now be specified as an expression. However, the
expression may not contain forward referenced symbols. The algorithm has been re-structurized.

22.09.94, V0.42:
INCLUDE directive improved: Environment variable "Z80_OZFILES" introduced to read a fixed path of all
Z88 OZ definition files. This makes it easier to port source code with regard to fetch the standard OZ files. Each
platform just presets the variable and the assembler will automatically expand the system file '#file' with a
leading path followed by 'file'.
O_BINARY mode included in open() function when creating a library file. This ensures compatibility with MSDOS files.
Bug in Z80asm_c fixed: -x option created library file as text file (no binary open mode). The file is now created as a
binary file. NB: This is only relevant for MSDOS (and LINUX/UNIX?).
27.09.94  LSTON/LSTOFF bug fixed: During INCLUDE file management, the old line of the previous file was written to
the list file when beginning/continuing on a new file. The listing file line is now initially cleared before pass 1
is executed.

19.10.94, V0.45:
New option added: -R. This Feature generates relocatable code, i.e. relocates it self before being
executed. A standard machine code routine is put in front of the code together wth a relocation table.
The generated machine code is self modifying and may only be executed in RAM (e.g.in Z88 BBC BASIC).
The help page has been slighty improved.

31.10.94: Relocator & relocation table structure changed. Each entry in the table is now defined as offsets from each
relocation address. Since relocation addresses mostly are less than 255 bytes apart, this design saves a lot of space
on the relocation header, about 50%. The idea was suggested by Erling Jacobsen who noticed the principle in the C68
C compiler.
The relocation table contents allowes negative offsets. This may be useful since not all relocation code patch pointers
is historically organised. However, if two adjacent patch pointers are more than 32K apart it will not create the
proper offset pointer (due to an integer overflow).
01.11.94: -i option opened the library file with unnecessary mode flags. If the specified library file didn't exist, it
was automatically created. The routine then made the wrong assumptions of that file.

17.11.94, V0.46:
Expression parsing & evaluation added with ^ (power) operator. Binary XOR now uses the ':' symbol.
The power operator is useful it may be necessary to convert bit numbers 0-7 into an 8bit value using: 2^bitnumber.

18.11.94, V0.47:
The following undocumented Z80 instructions have been implemented:
SLL instruction (Shift Logical Left). 8Bit LD r,IXh/IXl/IYl/IYh & LD IXh/IXl/IYl/IYh,r . INC/DEC IXl,IXh,IYl,IYh.
AND, ADD, ADC, SUB, SBC, CP, OR & XOR IXl/IXh/IYl/IYh .

30.11.94, V0.48:
Library filenames may now be omitted which is interpreted as the standard library filename.
Since the standard library is used most of the time it is considerably easier to just specify '-i' or '-x' without
a filename.
The default library filename is defined in an environment variable 'Z80_STDLIB'.

01.01.95, V0.49:
New feature in expressions implemented: Leading '#' in expressions defines a constant expression.
This is necessary when calculating relocatable address offsets and avoiding it to be interpreted as a relocatable
address to be manipulated during a -R option.
'#ASMPC' changed to 'ASMPC'
05.01.95: Bug in -D option fixed: first character of identifier wasn't converted to upper case.
03.03.95: Evaluation stack algorithms optimized.
12.03.95: Patching on 16bit addresses optimized.

14.03.95, V0.50:
Bug in Condition() fixed: logical NOT algorithm were misplaced. Moved to Factor().
17.03.95: ORG is now only defined from keyboard at the beginning of the linking process, if no ORG
were defined during assembly of the first module.

21.04.95, V0.52:
New avltree algorithms used in Z80asm. Many symbol-related routines changed to new interface.
Forward-referenced symbols now finally deleted, in stead of being marked SYMREMOVED. find_symbol() now faster.

24.04.95, V0.53:
'ASMPC' standard identifier now implemented as part of the global symbol tables. This means that
that it is equal to all other created symbols. Both pass1(), pass2() and the linking process use the assembler PC.
The explicit code in define_symbol() and Factor() are finally removed, which has speeded up the algorithms.

25.04.95, V0.54:
standard avltree move() and copy() now used in stead of CopyTree() and ReorderSymbol().

27.04.95, V0.55:
-c option added, which split the compiled machine code into 16K blocks. Each file is identified
with a '_bnx' extension where 'x' defines the blocks 0 (the first) to 3 (total of 64K).

03.05.95, V0.56:
DEFGROUP improved; evaluable expressions may now be used (previously only constants).

03.06.95, V0.57:
compile option messages displayed before processing (response to selected command line option).
EvalExpr() slightly optimised: Identifier logic in expressions made faster.

22.06.95, V0.58:
Parsing logic improved, with a bugfix in IF conditional expressions: A comment after a conditional
expression wasn't skipped. Getsym() has now been improved to skip the rest of a line of a comment ; is found.
This has also lead to various improvements in the parsing logic code of the assembler.
Total of lines assembled is now also displayed after successfull compilation.

28.06.95, V0.59:
New Relocator routine implemented. Mapfile now adds relocation header offset to address labels if
relocation option, -R, was selected).

13.07.95, V0.60:
Syntax parsing improvement in DEFB, DEFW and DEFL directives.

14.11.95, V1.00:
Last changes before final release:
Syntax check on register mnemonics improved.
XLIB improved to issue implicit MODULE definition.

20.02.96, V1.01 (gbs):
Minor bug fixed for signed 8bit operands:
If say, LD (IX+$FF),A were used, the assembler gave an error. It shouldn't. The operand is now properly
sign-converted.

20.06.98, V1.0.3 (gbs):
Minor bug fixes in EOF handling in prsline.c, exprprsr.c and asmdrctv.c
prsident.c : SUB, AND, OR, XOR and CP instructions improved with "instr [A,]" syntax (allowing to specify "A,"
explicitly and thereby avoiding mis-interpretations).

03.09.98, V1.0.4 (gbs):
New command line option added: Use self defined source file extension, -e<ext> in stead of ".asm".
DEFVARS functionality extended with -1 which remembers last used offset.

07.03.99, V1.0.5 (dom):
Program terminates with 1 if an error occurs, otherwise 0 (implemented by Dominic Morris djm@jb.man.ac.uk).
Minor changes to remove silly warnings.

11.04.99, V1.0.6 (gbs):
C sources modified slighly a few lines to eliminate -Wall compiler warnings when using GNU C compiler
on Linux (now truly ANSI C conformant). All sources now reformatted according to GNU C programming style.
New option added: -o<filename> which allowes a different binary outfilename than otherwise based on
project filename.

16.04.99, V1.0.7 (gbs):
Assembler parses text files of arbitrary line feed standards; CR, LF or CRLF (OS independant text file parsing).
Command line symbol option to identify project files, #, has been changed to @ because # is regarded
as comment line identifier in UNIX shell environments - the result of this means that the file name is
discarded by the command line environment, when trying to compile a z80asm project.
Default -v option changed to -nv (verbose mode disabled by default).

30.04.99, V1.0.8 (gbs):
Error messages now extended with display of module name, if possible (request by Dominic Morris)
Basic file I/O error reported in new error message function to display proper error message.

02.05.99, V1.0.9 (gbs):
Directives XDEF, XREF, XLIB and LIB can now be defined arbitrarily in the asm source (before or after
the actual symbols names in question). Request by Dominic Morris of SmallC fame.
"LINUX" OS ID now changed to generic "UNIX" in compilation, since there's no Linux specifics in the
sources. Further, all UNIX's can successfully compile and execute z80asm.
Recursive include of same or mutual files now error trapped (new FindFile() function and changes to
INCLUDE() function).

04.05.99, V1.0.10 (gbs):
Bug fixes related to reading filenames from source files (filenames should not be case converted
because some filing systems look at filenames explicitely - with no case independency).
During create library, object offset now only displayed in verbose mode.
Filenames may now be specified with .asm at command line (stripped again internally). This is
useful since some OS's have true command line expansion, now allowing "z80asm *.asm" to get
all assembler source files pre-assembled.

30.05.99, V1.0.11 (gbs):
Binary() rewritten due to misbehaving functionality on MSDOS platform.
(reported by Keith Rickard, keithrickard@compuserve.com).
CreateLib() rewritten to replace the open() low level file I/O with high level
fopen() and fread() calls.

06.06.99, V1.0.12 (gbs):
MAXCODESIZE define moved to "config.h" where it also is defined for specific platforms.
For MSDOS the value is 65532 due to max heap size allocation per malloc() call.
(MSDOS BorlandC limitation reported by Dennis Gröning <dennisgr@algonet.se>)

DEFB, DEFW, DEFL & DEFM now implemented with proper MAXCODESIZE checking.
ReportError() now displays to stderr the actual MAXCODESIZE limit if it has been reached.

30.09.99, V1.0.13 (gbs)
CALL_PKG hard coded macro implemented for Garry Lancaster's Package system.

03.10.99, V1.0.13 (gbs)
Slight change to CALL_PKG(): 0 (zero) is allowed as parameter.

26.01.2000, V1.0.14 (gbs)
Expression range validation removed from 8bit unsigned (redundant) data storage.

28.01.2000, V1.0.15 (dom)
Fixed ParseIdent routine (was searching for IF,ELSE,ENDIF at one
position below there true place in the table) - this zapped
the HALT instruction and caused a Syntax Error report

Added the -M flag the change output files to .o from .obj

30.1.2000, V1.0.16 (gbs)
Dominic's -M option extended with argument, so that it may be possible
to define an arbitrary object file extension (max 3 chars), e.g.
-Mo to define .o extension.

26.02.2000, V1.0.17 (djm)
Added -C flag to output C source line number instead of asm line number
(if defined)
Added directive LINE <expr> to enable this
Allowed labels to start with an '_'

23.04.2000 (djm) [No version increment]
Added auto ENDIAN config if using GNU C

20.01.2001 <x1cygnus@xcalc.org> [No version increment]
Added hardcoded macro instruction Invoke and command line ti83plus
to make assembler ti83/83plus compatible

28.02.2001 V1.0.18 (djm)
Added UNDEFINE command to allow undefinition of a DEFINE

21.03.2001 v1.0.19 (djm)
Allowed labels to end in ':' and forsake the initial '.'

27.06.2001 [no version increment] (djm)
defs now takes a second parameter indicating what the filler byte should be, if not
set the defaults to 0

17.01.2001 [no version increment] (djm)
20h is now accepted as a synonym for $20

18.01.2001 [no version increment] (djm)
Dropped the requirement for add, sbc, and adc to specify "a," for 8 bit
operations
Added d and b specifiers for constants - decimal and binary
C-style 0x prefix for hex digits is permitted

22.04.2002 [no version increment] (Stefano)
IX <-> IY swap option added (-IXIY)


-------------------------------------------------------------------------------
09.07.2011 [1.1.1] (pauloscustodio)
-------------------------------------------------------------------------------
Based on 1.0.31

    Compiled with Visual C++ 2010, added casts to clean up warnings.
    Moved version strings to this file, created hist.h, for easy maintenance.
    Created HTML version of doc/z80asm.txt as doc/z80asm.html:
      - added table of contents to help looking up information
      - added documentation for options:
             -RCMX000, -plus, -IXIY, -C, -h, -I, -L, -sdcc, -forcexlib
      - added documentation for commands: INVOKE, LINE
      - added notes on deprecated error messages
    Started to build test suite in t/ *.t unsing Perl prove. Included test
    for all standard Z80 opcodes; need to be extended with directives and
    opcodes for Z80 variants.

    BUG_0001 : Error in expression during link, expression garbled - memory corruption?
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

    BUG_0002 : CreateLibFile and GetLibFile: buffer overrun
         When the Z80_STDLIB variable is defined, libfilename is allocated
         with one byte too short (strlen(filename) instead of strlen(filename)+1).

    BUG_0003 : Illegal options are ignored, although ReportError 9 (Illegal Option) exists
         set_asm_flag(): Some options were missing the 'return' statement,
         following through to the next tests; inserted 'return'
         in options 'M', 'I', 'L' and 'D'.
         Added ReportError 9 (Illegal Option) if the option is not recognized.

    CH_0001 : Assembly error messages should appear on stderr
         It's cumbersome to have to open .err files to see assembly errors.
         Changed ReportError() to Write error messages to stderr in addition
         to the .err file.

    BUG_0004 : 8bit unsigned constants are not checked for out-of-range
         Added the check

    BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary
         Accept (ix) and (iy), use offset zero.
         Raise syntax error for (ix 4), was accepting as (ix+4).

    CH_0002 : Unary plus and unary minus added to Factor()
         Accept unary minus and unary plus in factor to allow (ix+ -3) to be
         parsed as (ix-3).

-------------------------------------------------------------------------------
11.07.2011 [1.1.2] (pauloscustodio)
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
14.07.2011 [1.1.3] (pauloscustodio)
-------------------------------------------------------------------------------
    - Moved all error variables and error reporting code to a separate module
      errors.c, replaced all extern declarations of these variables by include
      errors.h, created symbolic constants for error codes.
    - Added test scripts for error messages.
    - Unified "Integer out of range" and "Out of range" errors; they are the
      same error.
    - Unified ReportIOError as ReportError(ERR_FILE_OPEN).

    CH_0003 : Error messages should be more informative
        - Added printf-args to error messages, added "Error:" prefix.

    BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
        - Raise ERR_UNBALANCED_PAREN instead.

-------------------------------------------------------------------------------
15.07.2011 [1.1.4] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced
        in tokid_t, causing expressions stored in object files to be wrong,
        e.g. VALUE-1 was stored as VALUE*1. This caused problems in expression
        evaluation in link phase.

-------------------------------------------------------------------------------
18.07.2011 [1.1.5] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0007 : memory leaks
        - Included code to run MS Visual Studio memory leak detection on a DEBUG
          build.
        - Cleaned memory leaks in main(), ReleaseModules(), DEFS().
        - Still memory leaks in main() in case of premature exit due to fatal
          errors;
          need to include exception mechanism to solve.

-------------------------------------------------------------------------------
05.08.2011 [1.1.6] (pauloscustodio)
-------------------------------------------------------------------------------
    CH_0004 : Exception mechanism to handle fatal errors
        - Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
        - Replaced all ERR_NO_MEMORY/return sequences by an exception,
          captured at main().
        - Replaced all the memory allocation functions malloc, calloc, ...
          by corresponding macros xmalloc, xcalloc, ... that raise an exception
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

-------------------------------------------------------------------------------
14.08.2011 [1.1.7] (pauloscustodio)
-------------------------------------------------------------------------------
    CH_0004(a) : Exception mechanism to handle fatal errors
        - New exception FatalErrorException to raise on fatal assembly errors
        - ReportError(), link_modules(), ModuleExpr(), CreateBinFile(),
          CreateLib(), INCLUDE(), BINARY(): throw the new exception
          FatalErrorException for fatal errors ERR_FILE_OPEN and ERR_MAX_CODESIZE
        - AssembleSourceFile(): added try-catch to delete incomplete files
          in case of fatal error, throw FatalErrorException instead of early
          return.
        - main(): added try-catch to delete incomplete library file in case of
          fatal error.
        - Z80pass1(), INCLUDE(): no need to check for fatal errors and return;
          bypassed by the exception mechanism.
        - AssembleSourceFile(): error return is never used; changed to void.
        - source_file_open flag removed; z80asmfile is used for the same purpose.
        - Tests: Added test case to verify that incomplete files are deleted on error.
        - Hack to hide memory leak in e4c, line 647, when rethrow() is called.
          Reported to Exceptions4c project page http://code.google.com/p/exceptions4c/

-------------------------------------------------------------------------------
19.08.2011 [1.1.8] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0008 : code block of 64K is read as zero
        - When linking a module with 64K of data no data is read from the
          object file because the code size is stored with two bytes = zero.
        - Problem is masked if the module with 64K is the only module linked
          because the linker reuses the code block left by the assembler,
          which still contains the code.

    BUG_0009 : file read/write not tested for errors
        - In case of disk full file write fails, but assembler does not
          detect the error and leaves back corruped object/binary files
        - Created new exception FileIOException and ERR_FILE_IO error.
        - Created new functions xfput_u8, xfget_u8, ... to raise the
          exception on error.

    BUG_0010 : heap corruption when reaching MAXCODESIZE
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
        - Renamed ReadLong/WriteLong to xfget_i32/xfput_u32 for symetry.

-------------------------------------------------------------------------------
29.09.2011 [1.1.9] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0012 : binfilename[] array is too short, should be FILENAME_MAX

    CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
        - Factor all pathname manipulation into module file.c.
        - Make default extensions constants.
        - Factor FILEEXT_SEPARATOR into config.h.
        - Move asm_ext[] and obj_ext[] to the options.c module.

-------------------------------------------------------------------------------
30.09.2011 [1.1.10] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0014 : -x./zx_clib should create ./zx_clib.lib but actually creates .lib
    (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
        - path_remove_ext() removed everything after last ".", ignoring directory
          separators. Fixed.

    - asm_ext initialization moved from main() to reset_options()

-------------------------------------------------------------------------------
07.10.2011 [1.1.11] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0015 : Relocation issue - dubious addresses come out of linking
    (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
        - Introduced in version 1.1.8, when the CODESIZE and the codeptr
          were merged into the same entity.
        - This caused the problem because CODESIZE keeps track of the start
          offset of each module in the sequence they will appear in the object
          file, and codeptr is reset to the start of the codearea for each module.
          The effect was that all address calculations at link phase were
          considering a start offset of zero for all modules.
        - Moreover, when linking modules from a libary, the modules are pulled
          in to the code area as they are needed, and not in the sequence they
          will be in the object file. The start offset was being ignored and
          the modules were being loaded in the incorrect order
        - Consequence of these two issues were all linked addresses wrong for
          programs with more that one module.

-------------------------------------------------------------------------------
14.10.2011 [1.1.12] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0013 : defm check for MAX_CODESIZE incorrect
        - The code:
            defs 65535, 'a'
            defm "a"
          fails with: Error: File 'test.asm', at line 3, Max. code size of
          65536 bytes reached

    - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in
        check_space() from codearea.c.
    - Replace strncpy by strncat, when used to make a safe copy without buffer
        overruns. The former pads the string with nulls.
    - Move cpu_type to options.c.
    - Factor strtoupper() to new module strutil.c.
    - New path_basename() in file.c, change functions to return result string
        pointer.
    - Silence warnings with casts.

-------------------------------------------------------------------------------
05.04.2012 stefano
-------------------------------------------------------------------------------
    CH_0006 : New reserved words ASMTAIL and ASMSIZE
        New stuff for z80asm
        I just put in the version under developement of z80asm a couple of lines to
        handle two new reserved words: ASMTAIL and ASMSIZE.
        In my intention ASMTAIL could e used to define a good position for malloc()
        or for a stack overflow protection routine.

-------------------------------------------------------------------------------
12.05.2012 [1.1.13] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0016 : RCMX000 emulation routines not assembled when LIST is ON (-l)
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

-------------------------------------------------------------------------------
22.05.2012 [1.1.14] (pauloscustodio)
-------------------------------------------------------------------------------
    CH_0007 : Garbage collector
    - Added automatic garbage collection on exit and simple fence mechanism
      to detect buffer underflow and overflow, to xmalloc functions.
      No longer needed to call init_malloc().
      No longer need to try/catch during creation of memory structures to
      free partially created data - all not freed data is freed atexit().
      Renamed xfree0() to xfree().

    CH_0008 : Safe strings
    - New type sstr_t to hold strings with size to prevent buffer overruns.

    Internal cleanup:
    - Included OpenBSD queue.h
    - New init_except() to be called at start of main(), auto cleanup atexit().
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

-------------------------------------------------------------------------------
26.05.2012 [1.1.15] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0018 : stack overflow in '@' includes - wrong range check
        if (include_level < sizeof( includes ) - 1) compares size in bytes, not
        number of elements

    CH_0009 : define simple classes with ordered construction and destruction
        Simple classes defined in C with constructor, destructor and copy
        constructor defined.
        All objects that were not deleted during the program execution
        are orderly destroyed at the exit, i.e. by calling the destructor of
        each object, which in turn may call destructors of contained objects.

    CH_0010 : new string pool to hold strings for all program duration
        Keep pool of strings for all duration of the program.
        Most keywords in input program are the same, no need to keep several copies
        and manage strdup/free for each token.
        Strings with the same contents are reused.

    CH_0011 : new string list class to hold lists of strings
        Used to keep the include and lib search paths.
        Remove the global variables include_dir, lib_dir, and respective
        counts, create instead the paths in the options module and
        create new search_include_file() and search_lib_file()
        functions to replace SearchFile().

    CH_0012 : wrappers on OS calls to raise fatal error
        Remove all the checks for failure after fopen(), localize the error
        checking and fatal error in xfopen().
        Removed exception FileIOException and ERR_FILE_IO error.

    CH_0013 : new errors interface to decouple calling code from errors.c
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

    Internal cleanup:
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

-------------------------------------------------------------------------------
31.05.2012 [1.1.16] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0019 : z80asm closes a closed file handle, crash in Linux
        GetModuleSize() opens and closes the objfile, but keeps objfile
        as a stale FILE*. CloseFiles() closes any file that has a non-null
        FILE*, trying to close objfile again. This crahes in Linux.

-------------------------------------------------------------------------------
05.06.2012 [1.1.17] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0020 : Segmentation fault in ParseIdent for symbol not found with interpret OFF
        When a symbol is not found and iterpret is OFF, the exception condition
        is not detected and a NULL pointer is dereferenced.

-------------------------------------------------------------------------------
01.11.2012 [1.1.18] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0021 : need sign extension in 64-bit architectures
        Reading of object files failed in 64-bit architectures because
        0xFFFFFFFF was being checked against -1, which is true in 32-bit
        but not in 64-bit.

-------------------------------------------------------------------------------
03.11.2012 [1.1.19] (pauloscustodio)
-------------------------------------------------------------------------------
    BUG_0022 : Different behaviour in string truncation in strutil in Linux and Win32
        Linux vsnprintf always writes the null terminator, therefore requires
        buffer size as argument.
        Win32 vsnprintf writes the null terminator only if there is room at the
        end, and needs the null terminator to be added in case of buffer full.

    CH_0014 : New Dynamic Strings that grow automatically on creation / concatenation

    Internal cleanup:
    - Make mapfile static to module modlink.
    - Remove modsrcfile, not used.
    - GetModuleSize(): use local variable for file handle instead of objfile
    - stricompare() instead of Flncmp().
    - Split safe strings from strutil.c to safestr.c.
    - Use _MSC_VER instead of WIN32 for MS-C compiler specific code.

-------------------------------------------------------------------------------
20.01.2013 [1.1.20] (pauloscustodio)
-------------------------------------------------------------------------------
    CH_0015 : integer out of range error replaced by warning
		C compiler generates code "ld bc,-50000" which was causing the assembly
		to abort. Replace by warning message but assemble value.
		Warnings on ERR_INT_RANGE, ERR_INT_RANGE_EXPR.

    CH_0016 : StrHash class to create maps from string to void*
		Created the StrHash to create hash tables mapping string keys kept in
		strpool to void* user pointer. This will be used to solve BUG_0023.

	BUG_0023 : Error file with warning is removed in link phase
		z80asm -b f1.asm
		If assembling f1.asm produces a warning, the link phase removes the f1.err
		file hidding the warning.

	BUG_0024 : (ix+128) should show warning message
		Signed integer range was wrongly checked to -128..255 instead
		of -128..127

	BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
		jr instruction on address 0, with out of range argument ->
		jr calls error and writes incomplete opcode (only one byte);
		WriteListFile tries to list bytes from -1 to 1 -> crash

-------------------------------------------------------------------------------
12.02.2013 [1.1.21] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0026 : Incorrect paging in symbol list
		The pages including the header of each symbol list had one line less
		than the others - incorrect call of LineCounter().

	BUG_0027 : Incorrect tabulation in symbol list
		When symbols are longer than COLUMN_WIDTH by 1, one extra tab is
		output between symbol name and '=' sign.
		See CH_0017.

	BUG_0028 : Not aligned page list in symbol list with more that 18 references
		The page list of each symbol at the end of the list file is not aligned
		when there are more than 18 references of a symbol.
		The first line has 18 references, the next lines have 17.
		The '*' causes the 2nd and next lines to have misaligned references.

	CH_0017 : Align with spaces, deprecate -t option
		Replace TAB-printing logic by printf() field length specifier.
		Simpler code at the expense of longer output files, using spaces instead
		of TABs.
		Change list file, sym file, map file and def file.
		Change page metrics variables into constants.

    Internal cleanup:
	- Unified usage of integer types: int, char, Byte, UInt
	- New CLASS_LIST() to create lists of objects defined by CLASS()
	- New CLASS_HASH() to create hash tables of objects defined by CLASS()

-------------------------------------------------------------------------------
16.02.2013 [1.1.22] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode
		When the instruction assembles more than 4 bytes (e.g. defb), the
		assembly line is not aligned in the list file.
		The size of the EOL character was not taken into account in
		computing the list file patch address for the assembly bytes on the
		second and next lines, for more than 32 bytes instructions.

-------------------------------------------------------------------------------
19.02.2013 [1.1.23] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0030 : List bytes patching overwrites header
		When instruction is more than 32 bytes and second line of bytes is
		on a different page, the expression bytes are patched on the header
		line, because the offsets to the start of the list line stored in the
		expression are no longer true.

	BUG_0031 : List file garbled with input lines with 255 chars
		When the input line is the maximum size, the newline character is not
		read from file and the list output is garbled - missing newline.

    Internal cleanup:
	- New listfile.c with all the listing related code

-------------------------------------------------------------------------------
01.06.2013 [1.2.0] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0032 : DEFGROUP ignores name after assignment
		The code
			DEFGROUP {
				f10 = 10, f11
			}
		did not define f11 - all text after the expression was discarded.

	BUG_0033 : -d option fails if .asm does not exist
		When building test.o from test.c, the test.asm file is removed by zcc.
		If the .o is then linked into a library with the -d option to skip
		assembling, z80asm fails with error
		"Cannot open file 'test.asm' for reading".
		Bug introduced when replaced TestAsmFile() by query_assemble() in
		z80asm.c 1.78.

	BUG_0034 : If assembly process fails with fatal error, invalid library is kept
		Option -x creates an empty library file (just the header). If the
		assembly process fails with a fatal errror afterwards, the library file
		is not deleted.

	CH_0020 : ERR_ORG_NOT_DEFINED if no ORG given
		z80asm no longer asks for an ORG address from the standard input
		if one is not given either by an ORG statement or a -r option;
		it exists with an error message instead.
		The old behaviour was causing wrong build scripts to hang waiting
		for input.

	CH_0021 : Exceptions on file IO show file name
		Keep a hash table of all opened file names, so that the file name
		is shown on a fatal error.
		Rename file IO funtions: f..._err to xf...

	CH_0022 : Replace avltree by hash table for symbol table
		Replaced avltree from original assembler by hash table because:
		a) code simplicity
		b) performance - avltree 50% slower when loading the symbols from the
		   ZX 48 ROM assembly, see t\developer\benchmark_symtab.t
		Removed unused errors, replaced by assertion, code not reached:
		ERR_SYMBOL_DECL_GLOBAL, ERR_SYMBOL_DECL_EXTERN.
		Replaced error ERR_SYMBOL_REDECL_GLOBAL (not reached in compile phase)
		by ERR_SYMBOL_REDEFINED_MODULE (was printf).

    Internal cleanup:
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
	- Decouple module name creation from parsing, define CURRENTMODULE->mname
	  directly instead of calling DeclModuleName()
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

-------------------------------------------------------------------------------
11.06.2013 [1.2.1] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0035 : Symbol not defined in forward references
		Symbol not defined error when a symbol is used more than once before
		being defined. Consequence of removal of notdecl_tab symbol table.

	CH_0023 : Remove notdecl_tab
		Symbol is created in symbol table on first usage, SYM_DEFINED bit
		identifies if it was defined or not.

-------------------------------------------------------------------------------
15.06.2013 [1.2.2] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0036 : Map file does not show local symbols with the same name in different modules
		If the same local symbol is defined in multiple modules, only one of
		them appears in the map file.
		"None." is written in map file if no symbols are defined.

    Internal cleanup:
	- Move symbol creation logic fromReadNames() in  modlink.c to symtab.c.
	- Add error message for invalid symbol and scope chars in object file.
	- find_local_symbol() and find_global_symbol() to encapsulate usage of get_global_tab()

-------------------------------------------------------------------------------
15.06.2013 [1.2.3] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0037 : Symbol already defined error when symbol used in IF expression
		The code:
			IF !NEED_floatpack
				DEFINE	NEED_floatpack
			ENDIF
			defb NEED_floatpack
		fails with "Symbol 'NEED_FLOATPACK' already defined"

    Internal cleanup:
	- Move mapfile writing to mapfile.c.

-------------------------------------------------------------------------------
26.08.2013 [1.2.4] (pauloscustodio)
-------------------------------------------------------------------------------
    Internal cleanup:
	- Symbol_fullname() to return full symbol name NAME@MODULE.
	- get_all_syms() to get list of symbols matching a type mask,
	  use in mapfile to decouple it from get_global_tab()
	- Move deffile writing to deffile.c, remove global variable deffile.
	- New remove_all_{local,static,global}_syms( void ) functions
	  to encapsulate calls to get_global_tab().

-------------------------------------------------------------------------------
26.08.2013 [1.2.5] (pauloscustodio)
-------------------------------------------------------------------------------
	Bug report 2013-07-27 10:50:27 by rkd77
	-Wformat -Werror=format-security
		Some distributions build packages with -Wformat -Werror=format-security.
		Build of z88dk fails with these options.

-------------------------------------------------------------------------------
29.08.2013 [1.2.6] (pauloscustodio)
-------------------------------------------------------------------------------
	BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
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

	CH_0018 : Remove legacy '#' in include file
		According to the z80asm manual, the # sign is used to insert the
		Z80_OZFILES environment variable before the file name, but this
		is not done as the assembler searches for the include file in all
		the include path, which includes the Z80_OZFILES environment variable.
		Handling of '#' in INCLUDE removed.

-------------------------------------------------------------------------------
30.08.2013 [1.2.7] (pauloscustodio)
-------------------------------------------------------------------------------
	By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
	as an identifier reserved by the C standard for implementation-defined behaviour
	starting with two underscores.

-------------------------------------------------------------------------------
12.09.2013 [1.2.8] (pauloscustodio)
-------------------------------------------------------------------------------
	- Included GLIB in the Makefile options. Setup GLib memory allocation
	  functions to use xmalloc functions. Unified glib compilation options
	  between MinGW and Linux.
	- Replaced xmalloc et al with glib functions
	- Replaced e4c exception mechanism by a much simpler one based on a few
	  macros. The former did not allow an exit(1) to be called within a
	  try-catch block.
	- Created a code-generation mechanism for automatic execution of initialize
	  code before the main() function starts, and methods for struct malloc
	  and free calling constructors and destructors.
	- Force xmalloc to be the first include, to be able to use MSVC
	  memory debug tools
	- Removed xmalloc allocation checking code, use MSVC _CRTDBG_MAP_ALLOC instead.
	  Dump memory usage statistics at the end if MEMALLOC_DEBUG defined.
	- Replaced strpool code by GLib String Chunks.
	- New error module with one error function per error, no need for the error
	  constants. Allows compiler to type-check error message arguments.
	  Included the errors module in the init() mechanism, no need to call
	  error initialization from main(). Moved all error-testing scripts to
	  one file errors.t.
	- Integrate codearea in init() mechanism.
	- Create xfree() macro that NULLs the pointer after free, required
	  by z80asm to find out if a pointer was already freed.

-------------------------------------------------------------------------------
05.10.2013 [1.2.9] (pauloscustodio)
-------------------------------------------------------------------------------
	- New File and FileStack objects
	- Remove legacy xxx_err() interface
	- Renamed SzList to StringList, simplified interface by assuming that
	  list lives in memory util program ends; it is used for directory searches
	  only. Moved interface to strutil.c, removed strlist.c.
	- Removed normalize_eol.
	- Parse command line options via look-up tables.

-------------------------------------------------------------------------------
26.11.2013 [1.2.10] (pauloscustodio)
-------------------------------------------------------------------------------
	- mkinit.pl to generate new main function that calls a set of initializers
	  before user main()
	- Move FileStack implementation to scan.c, remove FileStack.
	- Move getline_File() to scan.c.
	- Move source code generation tools to dev/Makefile, only called on request,
	  and keep the generated files in z80asm directory, so that build does
	  not require tools used for the code generation (ragel, perl).
	- Remove code generation for structs - use CLASS macro instead.

-------------------------------------------------------------------------------
26.11.2013 [2.0.0] (pauloscustodio)
-------------------------------------------------------------------------------
	CH_0020: C-like expression syntax instead of old operators
	- Object and Library file version incremented to 02 due to incompatibility
	  with old expression syntax

-------------------------------------------------------------------------------
15.12.2013 [2.1.0] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0039: library not pulled in if XLIB symbol not referenced in expression
		A library must define one XLIB symbol and zero or more XDEF symbols.
		For the library to be pulled in to the linked binary, the XLIB
		symbol needs to be referenced by LIB and used in some expression.
		If one of the XDEF symbols is referenced by XREF and used in an
		expression, the library is not pulled in and the symbol is not found.

	- Move library modules independent from z80asm to the lib subdirectory.
	- Move memory allocation routines to lib/xmalloc, instead of glib,
	  introduce memory leak report on exit and memory fence check.

-------------------------------------------------------------------------------
30.12.2013 [2.1.1] (pauloscustodio)
-------------------------------------------------------------------------------
	- Replace code-generation for init() functions by macros in init.h
	  to help define init() and fini() functions per module.
	  Code generation complicates maintenance, as all the modules with init()
	  functions are coupled together, and it may not be clear how the init()
	  module appears.
	- Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
	  handles both dynamically allocated strings and fixed-size strings.
	- Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
	  g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.

-------------------------------------------------------------------------------
18.02.2014 [2.1.2] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0040: Detect and report division by zero instead of crashing
	BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
	
	- Move generic utility functions to lib/
	- List, StrHash classlist and classhash receive the address of the container
	  object in all functions that add items to the container, and create the
	  container on first use. This allows a container to be staticaly
	  initialized with NULL and instantiated on first push/unshift/set.
	- Add count attribute to StrHash, classhash to count elements in container.
	- Add free_data attribute in StrHash to register a free fucntion to delete
	  the data container when the hash is removed or a key is overwritten.
	- glib dependency removed from code and Makefile
	- Decouple file.c from errors.c by adding a call-back mechanism in file for
	  fatal errors, setup by errors_init()
	- model.c to hold global data model

-------------------------------------------------------------------------------
19.02.2014 [2.1.3] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0042: 64-bit portability issues
		size_t changes to unsigned long in 64-bit. Usage of size_t * to 
		retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
		breaks on a 64-bit architecture. Make the functions return the value instead 
		of being passed the pointer to the return value, so that the compiler
		takes care of size convertions.
		Create UInt, use UInt instead of size_t.
		
-------------------------------------------------------------------------------
01.03.2014 [2.1.4] (pauloscustodio)
-------------------------------------------------------------------------------
	CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
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

-------------------------------------------------------------------------------
06.03.2014 [2.1.5] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0043: buffer overflow on constants longer than 128 chars in object file
		z80asm crashed when the expression to be stored in the object file was
		longer than the maximum allocated size (128). Changed to dynamic string.

-------------------------------------------------------------------------------
29.03.2014 [2.1.6] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0044: binary constants with more than 8 bits not accepted
		Limit of 8 bits removed.
	
	CH_0022: Added syntax to define binary numbers as bitmaps, e.g.
			defb @"--------"	; 0x00
			defb @"---##---"	; 0x18
			defb @"--#--#--"	; 0x24
			defb @"-#----#-"	; 0x42
			defb @"-######-"	; 0x7E
			defb @"-#----#-"	; 0x42
			defb @"-#----#-"	; 0x42
			defb @"--------"	; 0x00
	  
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
	  
	- Accept both "ex af,af" and "ex af,af'"

-------------------------------------------------------------------------------
03.04.2014 [2.1.7] (pauloscustodio)
-------------------------------------------------------------------------------
	CH_0023: Accept C-like escape sequences in character constants and strings
		Accepts \a, \b, \e (0x1B), \f, \n, \r, \t, \v, \{any character} 
		\{octal}, \x{hexadecimal}, allows \0 within the string.
		Existing code may have to be modified, e.g.
			defb '\' 	--> defb '\\'	

	BUG_0045: -D did not accept symbols starting with '_'
		(reported and fixed by alvin_albrecht@hotmail.com)
	
-------------------------------------------------------------------------------
13.04.2014 [2.1.8] (pauloscustodio)
-------------------------------------------------------------------------------
	CH_0024: Case-preserving, case-insensitive symbols
		Symbols no longer converted to upper-case, but still case-insensitive 
		searched. Warning when a symbol is used with different case than
		defined. Intermidiate stage before making z80asm case-sensitive, to
		be more C-code friendly.
		
	CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
		Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
		Remove 'X' scope for symbols in object files used before for XLIB -
		all PUBLIC symbols have scope 'G'.
		Remove SDCC hack on object files trating XLIB and XDEF the same.
		Created a warning to say XDEF et.al. are deprecated, but for the 
		momment keep it commented.

	- Merge test files.
	- Remove token.c module - no longer needed with the ragel scanner.

-------------------------------------------------------------------------------
23.04.2014 [2.2.0] (pauloscustodio)
-------------------------------------------------------------------------------
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

	BUG_0046: Expressions stored in object file with wrong values in MacOS
		Symthom: ZERO+2*[1+2*(1+140709214577656)] stored instead of ZERO+2*[1+2*(1+2)]
		Problem caused by non-portable way of repeating a call to vsnprintf without 
		calling va_start in between. The repeated call is necessary when the 
		dynamically allocated string needs to grow to fit the value to be stored.

	BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
		ASMPC is computed on zero-base address of the code section and expressions
		including ASMPC are not relocated at link time.
		"call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
		The expression ASMPC+3 is not marked as relocateable, and the resulting
		code only works when linked at address 0.

	BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
		In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead 
		of instruction-address.

    BUG_0011: ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
        - Bug only happens with forward references to relative addresses in
          expressions.
        - See example from zx48.asm ROM image in t/BUG_0011.t test file.
        - Need to change object file format to correct - need patchptr and
          address of instruction start.

	- Change struct expr to Expr class, use CLASS_LIST instead of linked list
	  manipulating.
	- Factor parsing and evaluating contants.
	- Factor symbol-not-defined error during expression evaluation.
	- Store module name in strpool instead of xstrdup/xfree.
	- Fix test scripts to run in UNIX.
	- As inc_PC() is no longer needed, append_opcode() no longer makes sense.
	  Removed append_opcode() and created a new helper append_2bytes().

-------------------------------------------------------------------------------
25.05.2014 [2.2.1] (pauloscustodio)
-------------------------------------------------------------------------------
	BUG_0049: Making a library with -d and 512 object files fails - Too many open files
		Error caused by z80asm not closing the intermediate object files, when
		assembling with -d.

	BUG_0050: Making a library with more than 64K and -d option fails - max. code size reached
		When a library is built with -d, and the total size of the loaded 
		modules is more than 64K, z80asm fails with "max. code size reached".

	BUG_0051: DEFC and DEFVARS constants do not appear in map file
		Constants defined with DEFC and DEFVARS, and declared PUBLIC are not
		written to the map file.
		Logic to select symbols for map and def files was wrong.

	- Cleanup test files
	- Parse argv generates list of files that can be iterated by assembler,
	  linker and librarian.
	- Move load_module_object() that loads object file size when assembling
	  with -d option to objfile.c. 
	- Add ASMHEAD symbol at the end of link with address of start of linked code.
	- Link expressions to the section they refer to.

-------------------------------------------------------------------------------
29.05.2014 [2.3.0] (pauloscustodio)
-------------------------------------------------------------------------------
	CH_0025: Link-time expression evaluation errors show source filename and line number
		Object file format changed to version 04, to include the source file 
		location of expressions in order to give meaningful link-time error messages.

-------------------------------------------------------------------------------
24.06.2014 [2.4.0] (pauloscustodio)
-------------------------------------------------------------------------------
	- Object file format changed to version 05, to include section names for 
	  expressions, names and object code.
	
	- Write expressions to object file only in pass 2, to remove dupplicate code
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
	
-------------------------------------------------------------------------------
26.06.2014 [2.4.1] (pauloscustodio)
-------------------------------------------------------------------------------
	- Bugfix in sections: wrong address computation when symbols declared
	  public in a different section that the definition.
	  If a symbol was defined in the "code" section, and then declared public
	  in a "data" section, it was stored in the object file as if it was defined
	  in "data", causing wrong address computations at link time.

	- Write empty sections to the object file, to allow the user to define
	  the sections sequence in the final binary by writing a list of empty 
	  sections at the top of the source file, even if the source does not
	  assembly any data for some of the sections, e.g.:
			section code
			section data
			section bss

-------------------------------------------------------------------------------
11.09.2014 [2.5.0] (pauloscustodio)
-------------------------------------------------------------------------------
	- DEFC with expressions; expressions containing external symbols are 
	  stored in the object file and evaluated at link time.

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

-------------------------------------------------------------------------------
28.09.2014 [2.6.0] (pauloscustodio)
-------------------------------------------------------------------------------
	- Split binary files for each section with a defined ORG
	
	- Object file format changed to version 08, to include ORG address
      per section.
	  
-------------------------------------------------------------------------------
03.10.2014 [2.6.1] (pauloscustodio)
-------------------------------------------------------------------------------
	- Remove option -c (split in 16k blocks) - no longer necessary with
	  split binary files for each section with a defined ORG.
	  
-------------------------------------------------------------------------------
xx.xx.2014 [2.6.2] (pauloscustodio)
-------------------------------------------------------------------------------
	- Add lexer tokens for registers, CPU flags and DEFVARS size specifiers,
	  simplifying the parser. As a side effect register names can no longer 
	  be used as labels, but this would be confusing anyway.
	  
	- Implemented infrastructure to do parsing based on a RAGEL state machine, 
	  and to fall back to the original parser on error. Implemented the first
	  two simple opcodes (NOP and HALT) as a concept check.
	  
	- Implemented expression parsing within the RAGEL state machine, by calling
	  the existent recursive-descent parser.
	  
	- New opcodes.c module to store away all the Z80 opcode hex bytes.
	
	- IFDEF / ELSE / ENDIF implemented
	  
	- IFNDEF / ELSE / ENDIF implemented
	
	- New --split-bin option to split binary file per section. 
	
	- New ORG -1 to a section to be written to a new binary file, even if
	  the address is consecutive with the previous section.
	  
-------------------------------------------------------------------------------
FUTURE CHANGES - require change of the object file format
-------------------------------------------------------------------------------
	BUG_0038: library modules not loaded in sequence
		The library modules loaded to the linked binary file should respect
		the order given on the command line.
		"z80asm -ilib1 -ilib2 obj1.o obj2.o"
		should load obj1, obj2, objects from lib1, objects from lib2 in this
		order.
		The load order is today: obj1, obj2, and then all library modules
		required by obj1, and then library modules required by obj2,
		independently of the -i sequence.
		This poses problems when trying to keep all data at the end of the
		binary code by defining a library with all the data and linking it
		last in the command line - the -i sequence is not respected and the
		data appears in the middle of other library modules.

*/

#include "xmalloc.h"   /* before any other include */

#include "hist.h"

#define VERSION     "2.6.2f"
#define COPYRIGHT   "InterLogic 1993-2009, Paulo Custodio 2011-2014"

#ifdef QDOS
#include <qdos.h>

char _prog_name[] = "Z80asm";
char _version[] = VERSION;
char _copyright[] = "\x7f " COPYRIGHT;

void consetup_title();
void ( *_consetup )() = consetup_title;
int ( *_readkbd )( chanid_t, timeout_t, char * ) = readkbd_move;
struct WINDOWDEF _condetails =
{2, 1, 0, 7, 484, 256, 0, 0};
#endif

#ifdef AMIGA
char amiver[] = "$VER: z80asm " VERSION ", (c) " COPYRIGHT;
#endif

char copyrightmsg[] = "Z80 Module Assembler " VERSION ", (c) " COPYRIGHT;
