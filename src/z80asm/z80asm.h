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


$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.h,v 1.53 2014-05-02 21:34:58 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "config.h"
#include "types.h"
#include "sym.h"
#include <stdio.h>
#include <stdlib.h>

#define REG16_BC   0
#define REG16_DE   1
#define REG16_HL   2
#define REG16_SP   3
#define REG16_AF   4
#define REG16_IX   5
#define REG16_IY   6
#define REG16_AF1  7

#define FLAGS_NZ 0
#define FLAGS_Z  1
#define FLAGS_NC 2
#define FLAGS_C  3
#define FLAGS_PO 4
#define FLAGS_PE 5
#define FLAGS_P 6
#define FLAGS_M 7


extern FILE *objfile;
extern uint sizeof_relocroutine, sizeof_reloctable;

extern char *CreateLibfile( char *filename );
extern char *GetLibfile( char *filename );

extern void assemble_file( char *filename );
extern void Z80pass1( char *filename );

/*
* $Log: z80asm.h,v $
* Revision 1.53  2014-05-02 21:34:58  pauloscustodio
* byte_t, uint_t and ulong_t renamed to byte, uint and ulong
*
* Revision 1.52  2014/05/02 20:24:39  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.51  2014/04/22 23:32:42  pauloscustodio
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
* Revision 1.50  2014/03/29 00:33:29  pauloscustodio
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
* Revision 1.49  2014/03/18 22:44:03  pauloscustodio
* Scanner decodes a number into tok_number.
* GetConstant(), TK_HEX_CONST, TK_BIN_CONST and TK_DEC_CONST removed.
* ident[] replaced by tok_name.
*
* Revision 1.48  2014/03/16 23:57:06  pauloscustodio
* Removed global line[]
*
* Revision 1.47  2014/03/16 19:19:49  pauloscustodio
* Integrate use of srcfile in scanner, removing global variable z80asmfile
* and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
*
* Revision 1.46  2014/03/11 23:34:00  pauloscustodio
* Remove check for feof(z80asmfile), add token TK_END to return on EOF.
* Allows decoupling of input file used in scanner from callers.
* Removed TOTALLINES.
* GetChar() made static to scanner, not called by other modules.
*
* Revision 1.45  2014/03/11 00:21:33  pauloscustodio
* Removed Fetchfilename(), handled as TK_STRING in scanner
*
* Revision 1.44  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.43  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.42  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.41  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint and ulong, use uint instead of size_t.
*
* Revision 1.40  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.39  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.38  2013/10/03 23:48:31  pauloscustodio
* Parse command line options via look-up tables:
* -r, --origin=ORG_HEX
* 
* Revision 1.37  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
* 
* Revision 1.36  2013/09/01 11:59:05  pauloscustodio
* Force xmalloc to be the first include, to be able to use MSVC memory debug tools
* 
* Revision 1.35  2013/06/16 20:14:39  pauloscustodio
* Move deffile writing to deffile.c, remove global variable deffile
* 
* Revision 1.34  2013/06/15 00:26:23  pauloscustodio
* Move mapfile writing to mapfile.c.
* 
* Revision 1.33  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMSIZE, ASMTAIL
* 
* Revision 1.32  2013/06/08 23:07:53  pauloscustodio
* Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
* Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_def_sym()
*  and define_global_def_sym().
* 
* Revision 1.31  2013/06/01 01:24:22  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
* 
* Revision 1.30  2013/05/06 23:02:12  pauloscustodio
* BUG_0034 : If assembly process fails with fatal error, invalid library is kept
* Option -x creates an empty library file (just the header). If the
* assembly process fails with a fatal errror afterwards, the library file
* is not deleted.
* 
* Revision 1.29  2013/05/02 21:24:50  pauloscustodio
* Cleanup assemble login
* Removed global vars srcfilename, objfilename
* 
* Revision 1.28  2013/05/02 00:04:18  pauloscustodio
* Cleanup assemble decision logic
* 
* Revision 1.27  2013/04/22 21:23:38  pauloscustodio
* declare TOTALLINES
* 
* Revision 1.26  2013/04/06 13:15:04  pauloscustodio
* Move default asm and obj extension handling to file.c.
* srcfilename and objfilename are now pointers to static variables in file.c
* 
* Revision 1.25  2013/04/04 23:24:18  pauloscustodio
* Remove global variable errfilename
* 
* Revision 1.24  2013/04/04 23:08:18  pauloscustodio
* Helper functions to create file names of each of the extensions used in z80asm
* 
* Revision 1.23  2013/04/03 22:52:56  pauloscustodio
* Move libfilename to options.c, keep it in strpool
* 
* Revision 1.22  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
* 
* Revision 1.21  2013/02/12 00:55:00  pauloscustodio
* CH_0017 : Align with spaces, deprecate -t option
* 
* Revision 1.20  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
* 
* Revision 1.19  2012/06/07 11:54:13  pauloscustodio
* - Make mapfile static to module modlink.
* - Remove modsrcfile, not used.
* - GetModuleSize(): use local variable for file handle instead of objfile
* 
* Revision 1.18  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
* 
* Revision 1.17  2012/05/24 21:48:24  pauloscustodio
* Remove the global variables include_dir, lib_dir, and respective
* counts, create instead the paths in the options module and
* create new search_include_file() and search_lib_file()
* functions to replace SearchFile().
* 
* Revision 1.16  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
* 
* Revision 1.15  2012/05/20 06:01:03  pauloscustodio
* Moved MAXLINE, WIN32 versions of snprintf, vsnprintf to types.h
* 
* Revision 1.14  2012/05/17 14:47:39  pauloscustodio
* NUM_ELEMS() moved to types.h
* 
* Revision 1.13  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
* 
* Revision 1.12  2011/10/14 15:00:22  pauloscustodio
* - Move cpu_type to options.c.
* - Replace strncpy by strncat, when used to make a safe copy without buffer overruns. The former pads the string with nulls.
* - Factor strtoupper() to new module strutil.c.
* 
* Revision 1.11  2011/08/21 20:37:20  pauloscustodio
* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
* - Factor all pathname manipulation into module file.c.
* - Make default extensions constants.
* - Move asm_ext[] and obj_ext[] to the options.c module.
* 
* Revision 1.10  2011/07/14 01:32:08  pauloscustodio
*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
*     CH_0003 : Error messages should be more informative
*         - Added printf-args to error messages, added "Error:" prefix.
*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
*         - Raise ERR_UNBALANCED_PAREN instead
* 
* Revision 1.9  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
* 
* Revision 1.8  2011/07/11 16:16:45  pauloscustodio
* Moved all option variables and option handling code to a separate module options.c,
* replaced all extern declarations of these variables by include options.h.
* Created declarations in z80asm.h of objects defined in z80asm.c.
* 
* Revision 1.7  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
* 
* Revision 1.6  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
* 
* Revision 1.5  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
* 
* Revision 1.4  2011/07/09 01:38:02  pauloscustodio
* *** empty log message ***
* 
* Revision 1.3  2011/07/09 01:31:24  pauloscustodio
* Moved snprintf macro to z80asm.h
* 
* Revision 1.2  2009/07/18 23:23:15  dom
* clean up the code a bit more (Formatting and a fewer magic numbers)
* 
* Revision 1.1  2009/06/13 17:36:24  dom
* Add -I and -L to specify search paths for libraries and includes
* 
* $History: Z80ASM.C $
* 
*/
