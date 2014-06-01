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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/asmdrctv.c,v 1.98 2014-06-01 22:16:50 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include to enable memory leak detection */

#include "codearea.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "listfile.h"
#include "legacy.h"
#include "expr_def.h"
#include "options.h"
#include "scan.h"
#include "strpool.h"
#include "symbol.h"
#include "symtab.h"
#include "z80asm.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
int DEFSP( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
struct sourcefile *Prevfile( void );
struct sourcefile *FindFile( struct sourcefile *srcfile, char *fname );


/* local functions */
void DeclModuleName( void );
void DEFINE( void );
void UNDEFINE( void );


/* global variables */
extern uint32_t DEFVPC;


int
DEFSP( void )
{
    if ( GetSym() == TK_DOT )
        if ( GetSym() == TK_NAME )
            switch ( toupper(tok_name[0]) )
            {
            case 'B':
                return 1;

            case 'W':
                return 2;

            case 'P':
                return 3;

            case 'L':
                return 4;

            default:
                return -1;
            }
        else
        {
            error_syntax();
            return -1;
        }
    else
    {
        error_syntax();
        return -1;
    }
}



long
Parsevarsize( void )
{

    Expr *expr;

    long offset = 0, varsize, size_multiplier;

    if ( stricompare( tok_name, "DS" ) != 0 )
    {
        error_illegal_ident();
    }
    else
    {
        if ( ( varsize = DEFSP() ) == -1 )
        {
            error_unknown_ident();
        }
        else
        {
            GetSym();

            if ( ( expr = expr_parse() ) != NULL )
            {
                if ( expr->expr_type & NOT_EVALUABLE )
                {
                    error_not_defined();
                    OBJ_DELETE( expr );
                }
                else
                {
                    size_multiplier = Expr_eval( expr );
                    OBJ_DELETE( expr );

                    if ( size_multiplier > 0 && size_multiplier <= MAXCODESIZE )
                    {
                        offset = varsize * size_multiplier;
                    }
                    else
                    {
                        error_int_range( size_multiplier );
                    }
                }
            }
        }
    }

    return offset;
}



long
Parsedefvarsize( long offset )
{
    long varoffset = 0;

    switch ( tok )
    {
    case TK_NAME:
        if ( stricompare( tok_name, "DS" ) != 0 )
        {
            define_symbol( tok_name, offset, 0 );
            GetSym();
        }

        if ( tok == TK_NAME )
        {
            varoffset = Parsevarsize();
        }

        break;

    default:
        error_syntax();
    }

    return varoffset;
}



void
DEFVARS( void )
{
    Expr *expr;

    long offset;
    enum flag globaldefv;

    GetSym();

    if ( ( expr = expr_parse() ) != NULL )
    {
        /* expr. must not be stored in relocatable file */
        if ( expr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();
            OBJ_DELETE( expr );
            return;
        }
        else
        {
            offset = Expr_eval( expr ); /* offset expression must not contain undefined symbols */
            OBJ_DELETE( expr );
        }

        if ( ( offset != -1 ) && ( offset != 0 ) )
        {
            DEFVPC = (uint32_t)offset;
            globaldefv = ON;
        }
        else
        {
            if ( offset == -1 )
            {
                globaldefv = ON;
                offset = DEFVPC;
            }
            else
            {
                /* offset = 0, use temporarily without smashing DEFVPC */
                globaldefv = OFF;
            }
        }
    }
    else
    {
        return;    /* syntax error raised in expr_parse() - get next line from file... */
    }

    while ( tok != TK_END && tok != TK_LCURLY )
    {
        Skipline();

        EOL = FALSE;
        GetSym();
    }

    if ( tok == TK_LCURLY )
    {
        while ( tok != TK_END && GetSym() != TK_RCURLY )
        {
            if ( EOL )
            {
                EOL = FALSE;
            }
            else
            {
                offset += Parsedefvarsize( offset );
            }
        }

        if ( globaldefv == ON )
        {
            DEFVPC = (uint32_t)offset;
        }
    }
}



void
DEFGROUP( void )
{
    Expr *expr;
    long constant, enumconst = 0;
	DEFINE_STR( name, MAXLINE );

    while ( tok != TK_END && GetSym() != TK_LCURLY )
    {
        Skipline();
        EOL = FALSE;
    }

    if ( tok == TK_LCURLY )
    {
        while ( tok != TK_END && tok != TK_RCURLY )
        {
            if ( EOL )
            {
                EOL = FALSE;
            }
            else
            {
                do
                {
                    GetSym();

                    switch ( tok )
                    {
                    case TK_RCURLY:
                    case TK_NEWLINE:
                        break;

                    case TK_NAME:
						Str_set( name, tok_name );     /* remember name */

                        if ( GetSym() == TK_EQUAL )
                        {
                            GetSym();

                            if ( ( expr = expr_parse() ) != NULL )
                            {
                                if ( expr->expr_type & NOT_EVALUABLE )
                                {
                                    error_not_defined();
                                }
                                else
                                {
                                    constant = Expr_eval( expr );
                                    enumconst = constant;
                                    define_symbol( name->str, enumconst++, 0 );
                                }

                                OBJ_DELETE( expr );
                            }

                            /* BUG_0032 - removed: GetSym(); */
                        }
                        else
                        {
                            define_symbol( name->str, enumconst++, 0 );
                        }

                        break;

                    default:
                        error_syntax();
                        break;
                    }
                }
                while ( tok == TK_COMMA );   /* get enum definitions separated by comma in current line */

                Skipline();   /* ignore rest of line */
            }
        }
    }
}


void
DEFS()
{
    Expr *expr;
    Expr *constexpr;

    long constant = 0, val = 0;

    GetSym();                     /* get numerical expression */

    if ( ( expr = expr_parse() ) != NULL )
    {
        /* expr. must not be stored in relocatable file */
        if ( expr->expr_type & NOT_EVALUABLE )
        {
            /* BUG_0007 : memory leaks - was not being released in case of error */
            OBJ_DELETE( expr ); /* remove linked list, expression evaluated */
            error_not_defined();
        }
        else
        {
            constant = Expr_eval( expr );
            OBJ_DELETE( expr ); /* remove linked list, expression evaluated */

            if ( tok != TK_COMMA )
            {
                val = 0;
            }
            else
            {
                GetSym();

                if ( ( constexpr = expr_parse() ) != NULL )
                {
                    if ( constexpr->expr_type & NOT_EVALUABLE )
                    {
                        error_not_defined();
                    }
                    else
                    {
                        val = Expr_eval( constexpr );
                    }

                    OBJ_DELETE( constexpr );
                }
            }

            if ( constant >= 0 )
            {
                while ( constant-- )
                {
                    append_byte( (Byte) val );
                }
            }
            else
            {
                error_int_range( constant );
                return;
            }
        }
    }
}

void
UNDEFINE( void )
{
    Symbol *tok = NULL;

    do
    {
        if ( GetSym() == TK_NAME )
        {
            tok = find_local_symbol( tok_name );
        }

        if ( tok != NULL )
        {
            SymbolHash_remove( CURRENTMODULE->local_symtab, tok_name );
        }
        else
        {
            error_syntax();
            break;
        }
    }
    while ( GetSym() == TK_COMMA );
}

void
DEFINE( void )
{
    do
    {
        if ( GetSym() == TK_NAME )
        {
            define_local_def_sym( tok_name, 1 );
        }
        else
        {
            error_syntax();
            break;
        }
    }
    while ( GetSym() == TK_COMMA );
}


void
DEFC( void )
{
    Expr *expr;
    long constant;
	DEFINE_STR( name, MAXLINE );

    do
    {
        if ( GetSym() == TK_NAME )
        {
			Str_set( name, tok_name ); /* remember name */

            if ( GetSym() == TK_EQUAL )
            {
                GetSym();         /* get numerical expression */

                if ( ( expr = expr_parse() ) != NULL )
                {
                    /* expr. must not be stored in
                       * relocatable file */
                    if ( expr->expr_type & NOT_EVALUABLE )
                    {
                        error_not_defined();
	                    OBJ_DELETE( expr );
                        break;
                    }
                    else
                    {
                        constant = Expr_eval( expr );    /* DEFC expression must not
                                                                 * contain undefined symbols */
                        define_symbol( name->str, constant, 0 );
	                    OBJ_DELETE( expr );
                    }
                }
                else
                {
                    break;    /* syntax error - get next line from file... */
                }
            }
            else
            {
                error_syntax();
                break;
            }
        }
        else
        {
            error_syntax();
            break;
        }
    }
    while ( tok == TK_COMMA );       /* get all DEFC definition separated by comma */
}



void
ORG( void )
{

    Expr *expr;
    long constant;

    GetSym();                     /* get numerical expression */

    if ( ( expr = expr_parse() ) != NULL )
    {
        if ( expr->expr_type & NOT_EVALUABLE )
        {
            error_not_defined();
        }
        else
        {
            constant = Expr_eval( expr );       /* ORG expression must not contain undefined symbols */

            if ( constant >= 0 && constant <= 65535 )
            {
                CURRENTMODULE->origin = constant;
            }
            else
            {
                error_int_range( constant );
            }
        }

        OBJ_DELETE( expr );
    }
}


void
DEFB( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprUnsigned8( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos++;

        if ( tok == TK_NEWLINE || tok == TK_END )
        {
            break;
        }
        else if ( tok != TK_COMMA )
        {
            error_syntax();
            break;
        }
    }
    while ( tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFW( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprAddress( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos += 2;

        if ( tok == TK_NEWLINE || tok == TK_END )
        {
            break;
        }
        else if ( tok != TK_COMMA )
        {
            error_syntax();
            break;
        }
    }
    while ( tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFP( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprAddress( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos += 2;

        /* Pointers must be specified as WORD,BYTE pairs separated by commas */
        if ( tok != TK_COMMA )
        {
            error_syntax();
        }

        GetSym();

        if ( !ExprUnsigned8( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos++;

        if ( tok == TK_NEWLINE || tok == TK_END )
        {
            break;
        }
        else if ( tok != TK_COMMA )
        {
            error_syntax();
            break;
        }
    }
    while ( tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFL( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

        if ( !ExprLong( bytepos ) )
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos += 4;

        if ( tok == TK_NEWLINE || tok == TK_END )
        {
            break;
        }
        else if ( tok != TK_COMMA )
        {
            error_syntax();
            break;
        }
    }
    while ( tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFM( void )
{
    long bytepos = 0;
	char *p;

    do
    {
        if ( GetSym() == TK_STRING )
        {
			for ( p = tok_string; *p != '\0'; p++ )
			{
                append_byte( (Byte) *p );
                ++bytepos;
			}

            GetSym();
            if ( tok != TK_STRING_CAT && tok != TK_COMMA && tok != TK_NEWLINE && tok != TK_END)
            {
                error_syntax();
                return;
            }
        }
        else
        {
            if ( !ExprUnsigned8( bytepos ) )
            {
                break;    /* syntax error - get next line from file... */
            }

            if ( tok != TK_STRING_CAT && tok != TK_COMMA && tok != TK_NEWLINE && tok != TK_END)
            {
                error_syntax(); /* expression separator not found */
                break;
            }

            ++bytepos;
        }
    }
    while ( tok != TK_NEWLINE && tok != TK_END );
}




void
INCLUDE( void )
{
    if ( GetSym() == TK_STRING )
    {
        Z80pass1( tok_string );				/* parse include file */
    }
    else
    {
        error_syntax();
    }

    tok = TK_NEWLINE;
}


void
BINARY( void )
{
    char      *filename;
    FILE          *binfile;
    long          Codesize;

    if ( GetSym() == TK_STRING )
    {
        filename = search_file( tok_string, opts.inc_path );

        binfile = xfopen( filename, "rb" );           /* CH_0012 */
        fseek( binfile, 0L, SEEK_END ); /* file pointer to end of file */
        Codesize = ftell( binfile );
        fseek( binfile, 0L, SEEK_SET ); /* file pointer to start of file */

        fread_codearea( binfile, Codesize );  /* read binary code */

        xfclose( binfile );
        binfile = NULL;
    }
    else
    {
        error_syntax();
    }
}


void
DeclModuleName( void )
{
    if ( CURRENTMODULE->modname == NULL )
    {
        if ( tok == TK_NAME )
        {
            CURRENTMODULE->modname = strpool_add( tok_name );
        }
        else
        {
            error_illegal_ident();
        }
    }
    else
    {
        error_module_redefined();
    }
}


/*
 * $Log: asmdrctv.c,v $
 * Revision 1.98  2014-06-01 22:16:50  pauloscustodio
 * Write expressions to object file only in pass 2, to remove dupplicate code
 * and allow simplification of object file writing code. All expression
 * error messages are now output only during pass 2.
 *
 * Revision 1.97  2014/05/25 01:02:29  pauloscustodio
 * Byte, Int, UInt added
 *
 * Revision 1.96  2014/05/17 14:27:12  pauloscustodio
 * Use C99 integer types 
 *
 * Revision 1.95  2014/05/06 22:52:01  pauloscustodio
 * Remove OS-dependent defines and dependency on ../config.h.
 * Remove OS_ID constant from predefined defines in assembly.
 *
 * Revision 1.94  2014/05/06 22:17:37  pauloscustodio
 * Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
 *
 * Revision 1.93  2014/05/04 18:05:39  pauloscustodio
 * Fix memory leak
 *
 * Revision 1.92  2014/05/02 21:34:58  pauloscustodio
 * byte_t and uint_t renamed to Byte, uint32_t
 *
 * Revision 1.91  2014/05/02 20:24:38  pauloscustodio
 * New class Module to replace struct module and struct modules
 *
 * Revision 1.90  2014/04/22 23:32:42  pauloscustodio
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
 * Revision 1.89  2014/04/18 17:46:18  pauloscustodio
 * - Change struct expr to Expr class, use CLASS_LIST instead of linked list
 *   manipulating.
 * - Factor parsing and evaluating contants.
 * - Factor symbol-not-defined error during expression evaluation.
 * - Store module name in strpool instead of xstrdup/xfree.
 *
 * Revision 1.88  2014/04/06 23:29:26  pauloscustodio
 * Removed lookup functions in token.c, no longer needed with the ragel based scanner.
 * Moved the token definitions from token_def.h to scan_def.h.
 *
 * Revision 1.87  2014/04/05 23:36:11  pauloscustodio
 * CH_0024: Case-preserving, case-insensitive symbols
 * Symbols no longer converted to upper-case, but still case-insensitive
 * searched. Warning when a symbol is used with different case than
 * defined. Intermidiate stage before making z80asm case-sensitive, to
 * be more C-code friendly.
 *
 * Revision 1.86  2014/03/29 00:11:51  pauloscustodio
 * TK_EOF renamed TK_END
 *
 * Revision 1.85  2014/03/22 16:15:24  pauloscustodio
 * Memory leak - delete expression if not defined
 *
 * Revision 1.84  2014/03/18 22:44:03  pauloscustodio
 * Scanner decodes a number into tok_number.
 * GetConstant(), TK_HEX_CONST, TK_BIN_CONST and TK_DEC_CONST removed.
 * ident[] replaced by tok_name.
 *
 * Revision 1.83  2014/03/17 00:07:53  pauloscustodio
 * Remove global stringconst[]
 *
 * Revision 1.82  2014/03/16 19:19:49  pauloscustodio
 * Integrate use of srcfile in scanner, removing global variable z80asmfile
 * and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
 *
 * Revision 1.81  2014/03/15 02:12:07  pauloscustodio
 * Rename last token to tok*
 * GetSym() declared in scan.h
 *
 * Revision 1.80  2014/03/11 23:34:00  pauloscustodio
 * Remove check for feof(z80asmfile), add token TK_END to return on EOF.
 * Allows decoupling of input file used in scanner from callers.
 * Removed TOTALLINES.
 * GetChar() made static to scanner, not called by other modules.
 *
 * Revision 1.79  2014/03/11 22:59:20  pauloscustodio
 * Move EOL flag to scanner
 *
 * Revision 1.78  2014/03/11 00:21:33  pauloscustodio
 * Removed Fetchfilename(), handled as TK_STRING in scanner
 *
 * Revision 1.77  2014/03/11 00:15:13  pauloscustodio
 * Scanner reads input line-by-line instead of character-by-character.
 * Factor house-keeping at each new line read in the scanner getasmline().
 * Add interface to allow back-tacking of the recursive descent parser by
 * getting the current input buffer position and comming back to the same later.
 * SetTemporaryLine() keeps a stack of previous input lines.
 * Scanner handles single-quoted strings and returns a number.
 * New error for single-quoted string with length != 1.
 * Scanner handles double-quoted strings and returns the quoted string.
 *
 * Revision 1.76  2014/03/05 23:44:55  pauloscustodio
 * Renamed 64-bit portability to BUG_0042
 *
 * Revision 1.75  2014/03/04 11:49:47  pauloscustodio
 * Expression parser and expression evaluator use a look-up table of all
 * supported unary, binary and ternary oprators, instead of a big switch
 * statement to select the operation.
 * Expression operations are stored in a contiguous array instead of
 * a liked list to reduce administrative overhead of adding / iterating.
 *
 * Revision 1.74  2014/03/03 13:43:50  pauloscustodio
 * Renamed symbol and expression type attributes
 *
 * Revision 1.73  2014/03/03 13:27:06  pauloscustodio
 * Rename symbol type constants
 *
 * Revision 1.72  2014/03/01 15:45:31  pauloscustodio
 * CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
 * Handle C-like operators, make exponentiation (**) right-associative.
 * Simplify expression parser by handling composed tokens in lexer.
 * Change token ids to TK_...
 *
 * Revision 1.71  2014/02/25 22:39:34  pauloscustodio
 * ws
 *
 * Revision 1.70  2014/02/24 23:08:55  pauloscustodio
 * Rename "enum symbols" to "tokid_t", define in token.h
 *
 * Revision 1.69  2014/02/23 18:48:16  pauloscustodio
 * CH_0021: New operators ==, !=, &&, ||, ?:
 * Handle C-like operators ==, !=, &&, || and ?:.
 * Simplify expression parser by handling composed tokens in lexer.
 *
 * Revision 1.68  2014/02/19 23:59:26  pauloscustodio
 * BUG_0042: 64-bit portability issues
 * size_t changes to unsigned long in 64-bit. Usage of size_t * to
 * retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
 * breaks on a 64-bit architecture. Make the functions return the value instead
 * of being passed the pointer to the return value, so that the compiler
 * takes care of size convertions.
 * Create uint32_t, use uint32_t instead of size_t.
 *
 * Revision 1.67  2014/02/08 11:21:08  pauloscustodio
 * Moved srcfile.c to lib/
 *
 * Revision 1.66  2014/01/23 22:30:55  pauloscustodio
 * Use xfclose() instead of fclose() to detect file write errors during buffer flush called
 * at fclose()
 *
 * Revision 1.65  2014/01/20 23:29:17  pauloscustodio
 * Moved file.c to lib/fileutil.c
 *
 * Revision 1.64  2014/01/11 01:29:39  pauloscustodio
 * Extend copyright to 2014.
 * Move CVS log to bottom of file.
 *
 * Revision 1.63  2014/01/11 00:10:38  pauloscustodio
 * Astyle - format C code
 * Add -Wall option to CFLAGS, remove all warnings
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
 * Revision 1.61  2014/01/01 21:23:48  pauloscustodio
 * Move generic file utility functions to lib/fileutil.c
 *
 * Revision 1.60  2013/12/15 13:18:33  pauloscustodio
 * Move memory allocation routines to lib/xmalloc, instead of glib,
 * introduce memory leak report on exit and memory fence check.
 *
 * Revision 1.59  2013/10/05 10:54:35  pauloscustodio
 * Parse command line options via look-up tables:
 * -I, --inc-path
 * -L, --lib-path
 *
 * Revision 1.58  2013/10/05 08:14:43  pauloscustodio
 * Parse command line options via look-up tables:
 * -C, --line-mode
 *
 * Revision 1.57  2013/10/01 23:23:53  pauloscustodio
 * Parse command line options via look-up tables:
 * -l, --list
 * -nl, --no-list
 *
 * Revision 1.56  2013/09/27 01:14:33  pauloscustodio
 * Parse command line options via look-up tables:
 * --help, --verbose
 *
 * Revision 1.55  2013/09/22 21:34:48  pauloscustodio
 * Remove legacy xxx_err() interface
 *
 * Revision 1.54  2013/09/10 20:29:32  dom
 * Fix nested comment problem with clang
 *
 * Revision 1.53  2013/09/08 08:29:21  pauloscustodio
 * Replaced xmalloc et al with glib functions
 *
 * Revision 1.52  2013/09/08 00:43:58  pauloscustodio
 * New error module with one error function per error, no need for the error
 * constants. Allows compiler to type-check error message arguments.
 * Included the errors module in the init() mechanism, no need to call
 * error initialization from main(). Moved all error-testing scripts to
 * one file errors.t.
 *
 * Revision 1.51  2013/09/01 12:00:07  pauloscustodio
 * Cleanup compilation warnings
 *
 * Revision 1.50  2013/08/30 21:50:43  pauloscustodio
 * By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
 * as an identifier reserved by the C standard for implementation-defined behaviour
 * starting with two underscores.
 *
 * Revision 1.49  2013/08/29 21:42:10  pauloscustodio
 * comment
 *
 * Revision 1.48  2013/06/15 00:26:23  pauloscustodio
 * Move mapfile writing to mapfile.c.
 *
 * Revision 1.47  2013/06/14 22:14:36  pauloscustodio
 * find_local_symbol() and find_global_symbol() to encapsulate usage of get_global_tab()
 *
 * Revision 1.46  2013/06/08 23:37:32  pauloscustodio
 * Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
 *  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
 * Define keywords for special symbols ASMSIZE, ASMTAIL
 *
 * Revision 1.45  2013/06/01 01:24:21  pauloscustodio
 * CH_0022 : Replace avltree by hash table for symbol table
 *
 * Revision 1.44  2013/05/23 22:22:23  pauloscustodio
 * Move symbol to sym.c, rename to Symbol
 *
 * Revision 1.43  2013/05/12 19:39:32  pauloscustodio
 * warnings
 *
 * Revision 1.42  2013/03/06 00:02:17  pauloscustodio
 * 	BUG_0032 : DEFGROUP ignores name after assignment
 * 		The code
 * DEFGROUP {
 *   f10 = 10, f11
 * }
 * did not define f11 - all text after the expression was discarded.
 *
 * Revision 1.41  2013/03/04 23:23:37  pauloscustodio
 * Removed writeline, that was used to cancel listing of multi-line
 * constructs, as only the first line was shown on the list file. Fixed
 * the problem in DEFVARS and DEFGROUP. Side-effect: LSTOFF line is listed.
 *
 * Revision 1.40  2013/03/02 23:48:55  pauloscustodio
 * New __LEGACY_Z80ASM_SYNTAX define to mark code that should be removed but is kept
 * to keep backwards compatibility
 *
 * Revision 1.39  2013/02/27 22:34:16  pauloscustodio
 * Move include path search to srcfile.c
 *
 * Revision 1.38  2013/02/19 22:52:40  pauloscustodio
 * BUG_0030 : List bytes patching overwrites header
 * BUG_0031 : List file garbled with input lines with 255 chars
 * New listfile.c with all the listing related code
 *
 * Revision 1.37  2013/01/24 23:03:03  pauloscustodio
 * Replaced (unsigned char) by (Byte)
 * Replaced (unisigned int) by (uint32_t)
 * Replaced (short) by (int)
 *
 * Revision 1.36  2013/01/20 21:24:28  pauloscustodio
 * Updated copyright year to 2013
 *
 * Revision 1.35  2012/11/03 17:39:36  pauloscustodio
 * astyle, comments
 *
 * Revision 1.34  2012/06/07 11:54:13  pauloscustodio
 * - Make mapfile static to module modlink.
 * - Remove modsrcfile, not used.
 * - GetModuleSize(): use local variable for file handle instead of objfile
 *
 * Revision 1.33  2012/05/30 22:06:48  pauloscustodio
 * BUG_0019 : z80asm closes a closed file handle, crash in Linux
 *
 * Revision 1.32  2012/05/29 21:00:35  pauloscustodio
 * BUG_0019 : z80asm closes a closed file handle, crash in Linux
 *
 * Revision 1.31  2012/05/26 18:51:10  pauloscustodio
 * CH_0012 : wrappers on OS calls to raise fatal error
 * CH_0013 : new errors interface to decouple calling code from errors.c
 *
 * Revision 1.30  2012/05/24 21:48:24  pauloscustodio
 * Remove the global variables include_dir, lib_dir, and respective
 * counts, create instead the paths in the options module and
 * create new search_include_file() and search_lib_file()
 * functions to replace SearchFile().
 *
 * Revision 1.29  2012/05/24 17:09:27  pauloscustodio
 * Unify copyright header
 *
 * Revision 1.28  2012/05/23 20:45:42  pauloscustodio
 * Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
 * Add tests.
 *
 * Revision 1.27  2012/05/18 00:20:32  pauloscustodio
 * ParseIndent(): remove hard coded IDs of IF, ELSE, ENDIF
 * Z80ident[]: make always handling function the same name as assembler ident.
 *
 * Revision 1.26  2012/05/17 17:42:14  pauloscustodio
 * define_symbol() defined as void, a fatal error is
 * always raised on error.
 *
 * Revision 1.25  2012/05/11 19:29:49  pauloscustodio
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
 * Revision 1.24  2011/10/14 14:46:03  pauloscustodio
 * -  BUG_0013 : defm check for MAX_CODESIZE incorrect
 *  - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space() from codearea.c.
 *
 * Revision 1.23  2011/10/07 17:53:04  pauloscustodio
 * BUG_0015 : Relocation issue - dubious addresses come out of linking
 * (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
 * - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
 * - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
 * The effect was that all address calculations at link phase were considering
 *  a start offset of zero for all modules.
 * - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
 * - Consequence of these two issues were all linked addresses wrong.
 *
 * Revision 1.22  2011/08/19 15:53:58  pauloscustodio
 * BUG_0010 : heap corruption when reaching MAXCODESIZE
 * - test for overflow of MAXCODESIZE is done before each instruction at parseline(); 
 *	 if only one byte is available in codearea, and a 2 byte instruction is assembled, 
 *	 the heap is corrupted before the exception is raised.
 * - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
 *
 * Revision 1.21  2011/08/18 23:27:54  pauloscustodio
 * BUG_0009 : file read/write not tested for errors
 * - In case of disk full file write fails, but assembler does not detect the error
 *   and leaves back corruped object/binary files
 * - Created new exception FileIOException and ERR_FILE_IO error.
 * - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
 *
 * Revision 1.20  2011/08/14 19:46:46  pauloscustodio
 * - INCLUDE(), BINARY(): throw the new exception FatalErrorException for fatal error ERR_FILE_OPEN, no need to re-open the original source file after the error
 * - INCLUDE(): no need to check for fatal error and return; bypassed by exception mechanism
 * - source_file_open flag removed; z80asmfile is used for the same purpose
 *
 * Revision 1.19  2011/08/05 19:37:38  pauloscustodio
 * CH_0004 : Exception mechanism to handle fatal errors
 * Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
 * Replaced all functions that allocated memory structures by the new xcalloc_struct().
 * Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
 *
 * Revision 1.18  2011/07/18 00:52:01  pauloscustodio
 * Initialize MS Visual Studio DEBUG build to show memory leaks on exit
 * BUG_0007 : memory leaks - Cleaned memory leaks in DEFS()
 *
 * Revision 1.17  2011/07/14 01:32:08  pauloscustodio
 *     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
 *     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
 *     CH_0003 : Error messages should be more informative
 *         - Added printf-args to error messages, added "Error:" prefix.
 *     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
 *         - Raise ERR_UNBALANCED_PAREN instead
 *
 * Revision 1.16  2011/07/12 22:47:59  pauloscustodio
 * - Moved all error variables and error reporting code to a separate module errors.c,
 *   replaced all extern declarations of these variables by include errors.h,
 *   created symbolic constants for error codes.
 * - Added test scripts for error messages.
 *
 * Revision 1.15  2011/07/11 15:56:46  pauloscustodio
 * Moved all option variables and option handling code to a separate module options.c,
 * replaced all extern declarations of these variables by include options.h.
 *
 * Revision 1.14  2011/07/09 18:25:35  pauloscustodio
 * Log keyword in checkin comment was expanded inside Log expansion... recursive
 * Added Z80asm banner to all source files
 *
 * Revision 1.13  2011/07/09 17:36:09  pauloscustodio
 * Copied cvs log into Log history
 *
 * Revision 1.12  2011/07/09 01:46:00  pauloscustodio
 * Added Log keyword
 *
 * Revision 1.11  2011/07/09 01:14:13  pauloscustodio
 * added casts to clean up warnings
 *
 * Revision 1.10  2010/04/16 17:34:37  dom
 * Make line number an int - 32768 lines isn't big enough...
 *
 * Revision 1.9  2009/08/14 22:23:12  dom
 * clean up some compiler warnings
 *
 * Revision 1.8  2009/06/22 21:26:28  dom
 * don't expand a zero length file
 *
 * Revision 1.7  2009/06/13 17:36:24  dom
 * Add -I and -L to specify search paths for libraries and includes
 *
 * Revision 1.6  2003/10/11 15:41:04  dom
 * changes from garry
 *
 * - support for defp -> defp addr,bank
 * - square brackets can be used in expressions
 * - comma can be used in defm
 *
 * Revision 1.5  2002/02/20 21:37:57  dom
 * merged in changes from rc1.4 branch to handle empty lines in list files
 *
 * Revision 1.4  2001/06/27 08:53:28  dom
 * branches:  1.4.2;
 * Added a second parameter to defs to indicate what the filler byte should be
 *
 * Revision 1.3  2001/02/28 17:59:22  dom
 * Added UNDEFINE for undefining symbols, bumped version to 1.0.18
 *
 * Revision 1.2  2001/01/23 10:00:08  dom
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
 * Revision 1.4.2.1  2002/02/20 21:35:19  dom
 * changes from dennis to handle blank lines in file list files
 *
 */

/* $History: Asmdrctv.c $ */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:04 */
/* Updated in $/Z80asm */
/* MAXCODESIZE checking implemented for DEFB, DEFW, DEFL & DEFM. */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:27 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 0:57 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Binary() rewritten to replace low I/O open() with fopen(), fread(). */
/* Fetchfilename() now doesn't changed parsed filename due to UNIX OS. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:01 */
/* Updated in $/Z80asm */
/* INCLUDE() now validates for recursive including of identical files. */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:08 */
/* Updated in $/Z80asm */
/* DEFVARS functionality extended with -1 argument. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:21 */
/* Updated in $/Z80asm */
/* Version History Comment block syntax layout corrected. */

/*  */
/* *****************  Version 1  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 14:52 */
/* Created in $/Z80asm */
/* Improvements on defm() and Fetchfilename(): */
/* fgetc() logic now handled better according to EOF events. */
