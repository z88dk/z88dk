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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80pass.c,v 1.106 2014-06-13 19:14:04 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "hist.h"
#include "listfile.h"
#include "model.h"
#include "options.h"
#include "scan.h"
#include "srcfile.h"
#include "strutil.h"
#include "sym.h"
#include "symbol.h"
#include "z80asm.h"
#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* external functions */
void ParseIdent( enum flag interpret );

/* local functions */
void ifstatement( enum flag interpret );
void parseline( enum flag interpret );
void Z80pass2( void );
void WriteSymbolTable( char *msg, SymbolHash *symtab );
long Evallogexpr( void );
struct sourcefile *Prevfile( void );
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
struct sourcefile *Setfile( struct sourcefile *curfile, struct sourcefile *newfile, char *fname );
struct sourcefile *FindFile( struct sourcefile *srcfile, char *fname );


void Z80pass1( char *filename )
{
    if ( opts.verbose )
        printf( "Reading '%s'...\n", filename );	/* display name of file */

	src_push();
	{
		src_open( filename, opts.inc_path );
		tok = TK_NIL;
		while ( tok != TK_END )
			parseline( ON );              /* before parsing it */
	}
	src_pop();
}



void
parseline( enum flag interpret )
{
    next_PC();				/* update assembler program counter */
    EOL = FALSE;			/* reset END OF LINE flag */
    GetSym();

    if ( tok == TK_DOT || tok == TK_LABEL )
    {
        if ( interpret == ON )
        {
            /* Generate only possible label declaration if line parsing is allowed */
            if ( tok == TK_LABEL || GetSym() == TK_NAME )
            {
                /* labels must always be touched due to forward referencing problems in expressions */
                define_symbol( tok_name, get_PC(), SYM_ADDR | SYM_TOUCHED );

                GetSym();      /* check for another identifier */
            }
            else
            {
                error_illegal_ident();       /* a name must follow a label declaration */
                return;       /* read in a new source line */
            }
        }
        else
        {
            Skipline();
            tok = TK_NEWLINE;    /* ignore label and rest of line */
        }
    }

    switch ( tok )
    {
    case TK_NAME:
        ParseIdent( interpret );
        break;

    case TK_END:
    case TK_NEWLINE:
        break;                /* empty line, get next... */

    default:
        if ( interpret == ON )
        {
            error_syntax();    /* Syntax error */
        }
    }

    list_end_line();				/* Write current source line to list file */
}





/* multilevel contitional assembly logic */

void
ifstatement( enum flag interpret )
{
    if ( interpret == ON )
    {
        /* evaluate #if expression */
        if ( Evallogexpr() != 0 )
        {

            do
            {
                /* expression is TRUE, interpret lines until #else or #endif */
                if ( tok != TK_END )
                {
                    parseline( ON );
                }
                else
                {
                    return;    /* end of file - exit from this #if level */
                }
            }
            while ( ( tok != TK_ELSE_STMT ) && ( tok != TK_ENDIF_STMT ) );

            if ( tok == TK_ELSE_STMT )
            {
                do
                {
                    /* then ignore lines until #endif ... */
                    if ( tok != TK_END )
                    {
                        parseline( OFF );
                    }
                    else
                    {
                        return;
                    }
                }
                while ( tok != TK_ENDIF_STMT );
            }
        }
        else
        {
            do
            {
                /* expression is FALSE, ignore until #else or #endif */
                if ( tok != TK_END )
                {
                    parseline( OFF );
                }
                else
                {
                    return;
                }
            }
            while ( ( tok != TK_ELSE_STMT ) && ( tok != TK_ENDIF_STMT ) );

            if ( tok == TK_ELSE_STMT )
            {
                do
                {
                    if ( tok != TK_END )
                    {
                        parseline( ON );
                    }
                    else
                    {
                        return;
                    }
                }
                while ( tok != TK_ENDIF_STMT );
            }
        }
    }
    else
    {
        do
        {
            /* don't evaluate #if expression and ignore all lines until #endif */
            if ( tok != TK_END )
            {
                parseline( OFF );
            }
            else
            {
                return;    /* end of file - exit from this IF level */
            }
        }
        while ( tok != TK_ENDIF_STMT );
    }

    tok = TK_NIL;
}



long
Evallogexpr( void )
{
    long constant;

    GetSym();							/* get logical expression */

	constant = expr_parse_eval_if();	/* ignore errors */

    return constant;
}


void
Z80pass2( void )
{
	ExprListElem *iter;
    Expr *expr;
    long value;
    UInt patchptr;
	Bool do_patch, do_store;

	iter = ExprList_first( CURRENTMODULE->exprs );
	while ( iter != NULL )
	{
		expr = iter->obj;

        /* set error location */
		set_error_null();
        set_error_file( expr->filename );
        set_error_line( expr->line_nr );

		/* Define code location; BUG_0048 */
		set_PC( expr->asmpc );		

		/* try to evaluate expression to detect missing symbols */
		value = Expr_eval( expr );

		/* check if expression is stored in object file or computed and patched */
		do_patch = TRUE;
		do_store = FALSE;

		if ( ( expr->expr_type & RANGE ) == RANGE_JROFFSET )
		{
			if ( expr->expr_type & EXPR_EXTERN )
			{
				error_jr_not_local();	/* JR must be local */
				do_patch = FALSE;
			}
		}
		else if ( ( expr->expr_type & EXPR_EXTERN ) || ( expr->expr_type & EXPR_ADDR ) )
		{
			do_patch = FALSE;
			do_store = TRUE;            /* store expression in relocatable file */
		}
		else if ( ( expr->expr_type & NOT_EVALUABLE ) )
		{
			error_not_defined();
			do_patch = FALSE;
		}

        if ( do_patch )
        {
            patchptr = expr->code_pos;            /* index in memory buffer */

            switch ( expr->expr_type & RANGE )
            {
            case RANGE_JROFFSET:
                value -= get_PC() + 2;		/* get module PC at JR instruction */

                if ( value >= -128 && value <= 127 )
                {
                    patch_byte( &patchptr, (Byte) value );
                    /* opcode is stored, now store relative jump */
                }
                else
                {
                    error_int_range( value );
                }
                break;

            case RANGE_8UNSIGN:
                if ( value < -128 || value > 255 )
                    warn_int_range( value );

                patch_byte( &patchptr, (Byte) value );
                break;

            case RANGE_8SIGN:
                if ( value < -128 || value > 127 )
                    warn_int_range( value );

                patch_byte( &patchptr, (Byte) value );
                break;

            case RANGE_16CONST:
                if ( value < -32768 || value > 65535 )
                    warn_int_range( value );

                patch_word( &patchptr, ( int ) value );
                break;

            case RANGE_32SIGN:
                if ( value < LONG_MIN || value > LONG_MAX )
                    warn_int_range( value );

                patch_long( &patchptr, value );
                break;

			default:
				assert(0);
            }
        }

		if ( opts.list )
			list_patch_data( expr->listpos, value, RANGE_SIZE( expr->expr_type ) );
			
		/* continue loop - delete expression unless needs to be stored in object file */
		if ( do_store )
			iter = ExprList_next( iter );
		else
		{
			/* extract current expression (same as expr), advance iterator */
			expr = ExprList_remove( CURRENTMODULE->exprs, &iter );
			OBJ_DELETE( expr );		
		}
    }

    /* clean error location */
    set_error_null();
    //set_error_module( CURRENTMODULE->modname );

	/* define origin from command line on first module */
    if ( CURRENTMODULE == get_first_module( NULL ) && opts.origin >= 0 )
        CURRENTMODULE->origin = opts.origin;

	/* create object file */
	if ( ! get_num_errors() )
		write_obj_file( CURRENTMODULE->filename, CURRENTMODULE );

    if ( ! get_num_errors() && opts.symtable )
    {
        WriteSymbolTable( "Local Module Symbols:", CURRENTMODULE->local_symtab );
        WriteSymbolTable( "Global Module Symbols:", global_symtab );
    }
}


Bool
Pass2info( int range,					/* allowed size of value to be parsed */
           long byteoffset )			/* position in listing file to patch */
{
    Expr *expr = expr_parse();
	int i;

	if ( expr != NULL )
	{
		expr->expr_type |= (range & RANGE);
		if ( opts.cur_list )
			expr->listpos = list_patch_pos( byteoffset );	/* now calculated as absolute file pointer */
		else
			expr->listpos = -1;

		ExprList_push( & CURRENTMODULE->exprs, expr );
	}

	/* reserve space */
	for ( i = 0; i < RANGE_SIZE( range ); i++ )
		append_byte( 0 );

	return expr == NULL ? FALSE : TRUE;
}


void
WriteSymbolTable( char *msg, SymbolHash *symtab )
{
    SymbolHashElem *iter;
    Symbol         *sym;

    /* dump all symbols sorted by name */
    list_start_table( msg );

    SymbolHash_sort( symtab, SymbolHash_by_name );

    for ( iter = SymbolHash_first( symtab ); iter; iter = SymbolHash_next( iter ) )
    {
        sym = ( Symbol * )iter->value;

        if ( sym->owner == CURRENTMODULE )
        {
            /* Write only symbols related to current module */
            if ( ( sym->sym_type & SYM_LOCAL ) || ( sym->sym_type & SYM_PUBLIC ) )
            {
                if ( ( sym->sym_type & SYM_TOUCHED ) )
                {
                    list_symbol( sym->name, sym->value, sym->references );
                }
            }
        }

    }
}


/*
* $Log: z80pass.c,v $
* Revision 1.106  2014-06-13 19:14:04  pauloscustodio
* Move module list to module.c
*
* Revision 1.105  2014/06/13 16:00:46  pauloscustodio
* Extended codearea.c to support different sections of code.
*
* Revision 1.104  2014/06/09 13:15:27  pauloscustodio
* Int and UInt types
*
* Revision 1.103  2014/06/02 22:29:14  pauloscustodio
* Write object file in one go at the end of pass 2, instead of writing
* parts during pass 1 assembly. This allows the object file format to be
* changed more easily, to allow sections in a near future.
* Remove global variable objfile and CloseFiles().
*
* Revision 1.102  2014/06/01 22:16:50  pauloscustodio
* Write expressions to object file only in pass 2, to remove dupplicate code
* and allow simplification of object file writing code. All expression
* error messages are now output only during pass 2.
*
* Revision 1.101  2014/05/29 00:19:37  pauloscustodio
* CH_0025: Link-time expression evaluation errors show source filename and line number
* Object file format changed to version 04, to include the source file
* location of expressions in order to give meaningful link-time error messages.
*
* Revision 1.100  2014/05/25 12:55:03  pauloscustodio
* Link expressions to the section they refer to.
*
* Revision 1.99  2014/05/25 01:02:30  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.98  2014/05/18 16:05:28  pauloscustodio
* Add sections to the Module structure, define default section "".
* Move module expressions to the Section structure.
*
* Revision 1.97  2014/05/17 14:27:13  pauloscustodio
* Use C99 integer types
*
* Revision 1.96  2014/05/06 22:52:02  pauloscustodio
* Remove OS-dependent defines and dependency on ../config.h.
* Remove OS_ID constant from predefined defines in assembly.
*
* Revision 1.95  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.94  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.93  2014/05/02 20:24:39  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.92  2014/04/22 23:32:42  pauloscustodio
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
* Revision 1.91  2014/04/18 17:46:18  pauloscustodio
* - Change struct expr to Expr class, use CLASS_LIST instead of linked list
*   manipulating.
* - Factor parsing and evaluating contants.
* - Factor symbol-not-defined error during expression evaluation.
* - Store module name in strpool instead of xstrdup/xfree.
*
* Revision 1.90  2014/04/15 20:06:44  pauloscustodio
* Solve warning: no newline at end of file
*
* Revision 1.89  2014/04/13 11:54:01  pauloscustodio
* CH_0025: PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
* Use new keywords PUBLIC and EXTERN, make the old ones synonyms.
* Remove 'X' scope for symbols in object files used before for XLIB -
* all PUBLIC symbols have scope 'G'.
* Remove SDCC hack on object files trating XLIB and XDEF the same.
* Created a warning to say XDEF et.al. are deprecated, but for the
* momment keep it commented.
*
* Revision 1.88  2014/03/29 00:32:46  pauloscustodio
* TK_EOF renamed TK_END
*
* Revision 1.87  2014/03/18 22:44:03  pauloscustodio
* Scanner decodes a number into tok_number.
* GetConstant(), TK_HEX_CONST, TK_BIN_CONST and TK_DEC_CONST removed.
* ident[] replaced by tok_name.
*
* Revision 1.86  2014/03/16 23:57:06  pauloscustodio
* Removed global line[]
*
* Revision 1.85  2014/03/16 19:19:49  pauloscustodio
* Integrate use of srcfile in scanner, removing global variable z80asmfile
* and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
*
* Revision 1.84  2014/03/15 02:12:07  pauloscustodio
* Rename last token to tok*
* GetSym() declared in scan.h
*
* Revision 1.83  2014/03/11 23:34:00  pauloscustodio
* Remove check for feof(z80asmfile), add token TK_END to return on EOF.
* Allows decoupling of input file used in scanner from callers.
* Removed TOTALLINES.
* GetChar() made static to scanner, not called by other modules.
*
* Revision 1.82  2014/03/11 22:59:20  pauloscustodio
* Move EOL flag to scanner
*
* Revision 1.81  2014/03/11 00:15:13  pauloscustodio
* Scanner reads input line-by-line instead of character-by-character.
* Factor house-keeping at each new line read in the scanner getasmline().
* Add interface to allow back-tacking of the recursive descent parser by
* getting the current input buffer position and comming back to the same later.
* SetTemporaryLine() keeps a stack of previous input lines.
* Scanner handles single-quoted strings and returns a number.
* New error for single-quoted string with length != 1.
* Scanner handles double-quoted strings and returns the quoted string.
*
* Revision 1.80  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.79  2014/03/04 11:49:47  pauloscustodio
* Expression parser and expression evaluator use a look-up table of all
* supported unary, binary and ternary oprators, instead of a big switch
* statement to select the operation.
* Expression operations are stored in a contiguous array instead of
* a liked list to reduce administrative overhead of adding / iterating.
*
* Revision 1.78  2014/03/03 14:09:20  pauloscustodio
* Renamed symbol type attribute
*
* Revision 1.77  2014/03/03 13:43:50  pauloscustodio
* Renamed symbol and expression type attributes
*
* Revision 1.76  2014/03/03 13:27:07  pauloscustodio
* Rename symbol type constants
*
* Revision 1.75  2014/03/02 12:51:41  pauloscustodio
* Change token ids to TK_...
*
* Revision 1.74  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.73  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.72  2014/02/23 18:48:46  pauloscustodio
* Extra parentheses removed.
*
* Revision 1.71  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.70  2014/02/11 15:27:19  pauloscustodio
* Removed Bison parser files (which where a very incomplete work in progress).
*
* Bison grammar not practical due to dual nature of z80asm keywords, i.e.
* DEFC NOP = 3 ; define a constant called NOP
* NOP ; assemble a NOP instruction
* LD A,NOP ; loads A with 3
*
* A Bison grammar requires the NOP to be a terminal token, which complicates
* the lexer to be able to return a NAME or a NOP depending on context.
*
* Revision 1.69  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.68  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.67  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
* 
* Revision 1.66  2014/01/05 23:20:39  pauloscustodio
* List, StrHash classlist and classhash receive the address of the container
* object in all functions that add items to the container, and create the
* container on first use. This allows a container to be staticaly
* initialized with NULL and instantiated on first push/unshift/set.
* Add count attribute to StrHash, classhash to count elements in container.
* Add free_data attribute in StrHash to register a free fucntion to delete
* the data container when the hash is removed or a key is overwritten.
* 
* Revision 1.65  2013/12/30 02:05:33  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
* 
* Revision 1.64  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
* 
* Revision 1.63  2013/12/11 23:33:55  pauloscustodio
* BUG_0039: library not pulled in if XLIB symbol not referenced in expression
* 
* Revision 1.62  2013/10/05 08:14:43  pauloscustodio
* Parse command line options via look-up tables:
* -C, --line-mode
* 
* Revision 1.61  2013/10/03 23:48:31  pauloscustodio
* Parse command line options via look-up tables:
* -r, --origin=ORG_HEX
* 
* Revision 1.60  2013/10/01 23:23:53  pauloscustodio
* Parse command line options via look-up tables:
* -l, --list
* -nl, --no-list
* 
* Revision 1.59  2013/10/01 22:50:27  pauloscustodio
* Parse command line options via look-up tables:
* -s, --symtable
* -ns, --no-symtable
* 
* Revision 1.58  2013/09/27 01:14:33  pauloscustodio
* Parse command line options via look-up tables:
* --help, --verbose
* 
* Revision 1.57  2013/09/24 00:05:36  pauloscustodio
* 
* Revision 1.56  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
* 
* Revision 1.55  2013/09/12 00:10:02  pauloscustodio
* Create xfree() macro that NULLs the pointer after free, required
* by z80asm to find out if a pointer was already freed.
* 
* Revision 1.54  2013/09/08 08:29:21  pauloscustodio
* Replaced xmalloc et al with glib functions
* 
* Revision 1.53  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
* 
* Revision 1.52  2013/06/15 00:26:23  pauloscustodio
* Move mapfile writing to mapfile.c.
* 
* Revision 1.51  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMSIZE, ASMTAIL
* 
* Revision 1.50  2013/06/08 23:07:53  pauloscustodio
* Add global ASMPC Symbol pointer, to avoid "ASMPC" symbol table lookup on every instruction.
* Encapsulate get_global_tab() and get_static_tab() by using new functions define_static_def_sym()
*  and define_global_def_sym().
* 
* Revision 1.49  2013/06/01 01:24:22  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
* 
* Revision 1.48  2013/05/23 22:22:23  pauloscustodio
* Move symbol to sym.c, rename to Symbol
* 
* Revision 1.47  2013/04/07 23:34:19  pauloscustodio
* CH_0020 : ERR_ORG_NOT_DEFINED if no ORG given
* z80asm no longer asks for an ORG address from the standard input
* if one is not given either by an ORG statement or a -r option;
* it exists with an error message instead.
* The old behaviour was causing wrong build scripts to hang waiting
* for input.
* 
* Revision 1.46  2013/04/06 13:15:04  pauloscustodio
* Move default asm and obj extension handling to file.c.
* srcfilename and objfilename are now pointers to static variables in file.c
* 
* Revision 1.45  2013/03/31 18:33:55  pauloscustodio
* Comments
* 
* Revision 1.44  2013/03/04 23:23:37  pauloscustodio
* Removed writeline, that was used to cancel listing of multi-line
* constructs, as only the first line was shown on the list file. Fixed
* the problem in DEFVARS and DEFGROUP. Side-effect: LSTOFF line is listed.
* 
* Revision 1.43  2013/02/27 20:47:53  pauloscustodio
* comments
* 
* Revision 1.42  2013/02/26 02:36:54  pauloscustodio
* Simplified symbol output to listfile by using SymbolRefList argument
* 
* Revision 1.41  2013/02/26 02:11:32  pauloscustodio
* New model_symref.c with all symbol cross-reference list handling
* 
* Revision 1.40  2013/02/22 17:26:34  pauloscustodio
* Decouple assembler from listfile handling
* 
* Revision 1.39  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
* 
* Revision 1.38  2013/02/16 09:46:55  pauloscustodio
* BUG_0029 : Incorrect alignment in list file with more than 4 bytes opcode
* 
* Revision 1.37  2013/02/12 00:58:13  pauloscustodio
* BUG_0027 : Incorrect tabulation in symbol list
* BUG_0028 : Not aligned page list in symbol list with more that 18 references
* CH_0017 : Align with spaces, deprecate -t option
* 
* Revision 1.36  2013/02/11 21:54:38  pauloscustodio
* BUG_0026 : Incorrect paging in symbol list
* 
* Revision 1.35  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (Byte)
* Replaced (unisigned int) by (UInt)
* Replaced (short) by (int)
* 
* Revision 1.34  2013/01/20 13:18:10  pauloscustodio
* BUG_0024 : (ix+128) should show warning message
* Signed integer range was wrongly checked to -128..255 instead
* of -128..127
* 
* Revision 1.33  2013/01/14 00:29:37  pauloscustodio
* CH_0015 : integer out of range error replaced by warning
* 
* Revision 1.32  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
* 
* Revision 1.31  2012/11/01 23:20:56  pauloscustodio
* Warinings due to missing include
* 
* Revision 1.30  2012/06/07 11:49:59  pauloscustodio
* stricompare() instead of Flncmp()
* 
* Revision 1.29  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
* 
* Revision 1.28  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
* 
* Revision 1.27  2012/05/20 06:39:27  pauloscustodio
* astyle
* 
* Revision 1.26  2012/05/20 06:02:09  pauloscustodio
* Garbage collector
* Added automatic garbage collection on exit and simple fence mechanism
* to detect buffer underflow and overflow, to xmalloc functions.
* No longer needed to call init_malloc().
* No longer need to try/catch during creation of memory structures to
* free partially created data - all not freed data is freed atexit().
* Renamed xfree0() to xfree().
* 
* Revision 1.25  2012/05/17 17:42:14  pauloscustodio
* define_symbol() defined as void, a fatal error is
* always raised on error.
* 
* Revision 1.24  2012/05/12 16:57:33  pauloscustodio
*     BUG_0016 : RCMX000 emulation routines not assembled when LIST is ON (-l)
*         The code "cpi" is assembled as "call rcmx_cpi" when option -RCMX000 is ON.
*         This is implemented by calling SetTemporaryLine() to insert new code
*         at the current input position.
*         When LIST is ON, getasmline() remembers the input file position, reads
*         the next line and restores the file position. It ignores the buffer
*         set by SetTemporaryLine(), causing the assembler to skip
*         the "call rcmx_cpi" line.
*         Also added registry of rcmx_cpi as external library routine.
* 
* Revision 1.23  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs,
* indenting style, space padding in parentheses and operators. Options written in the makefile,
* target astyle.
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
* Revision 1.22  2011/10/14 14:46:03  pauloscustodio
* -  BUG_0013 : defm check for MAX_CODESIZE incorrect
*  - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space()
*  from codearea.c.
* 
* Revision 1.21  2011/10/07 17:53:04  pauloscustodio
* BUG_0015 : Relocation issue - dubious addresses come out of linking
* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
* - This caused the problem because CODESIZE keeps track of the start offset of each module in the
*   sequence they will appear in the object file, and codeptr is reset to the start of the codearea
*   for each module.
*   The effect was that all address calculations at link phase were considering a start offset of zero
*   for all modules.
* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they
*   are needed, and not in the sequence they will be in the object file. The start offset was being
*   ignored and the modules were being loaded in the incorrect order
* - Consequence of these two issues were all linked addresses wrong.
* 
* Revision 1.20  2011/08/21 20:37:20  pauloscustodio
* CH_0005 : handle files as char[FILENAME_MAX] instead of strdup for every operation
* - Factor all pathname manipulation into module file.c.
* - Make default extensions constants.
* - Move asm_ext[] and obj_ext[] to the options.c module.
* 
* Revision 1.19  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte
*   is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the
*   exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on
*   every write.
* 
* Revision 1.18  2011/08/19 10:20:32  pauloscustodio
* - Factored code to read/write word from file into xfget_u16/xfput_u16.
* - Renamed ReadLong/WriteLong to xfget_i32/xfput_u32 for symetry.
* 
* Revision 1.17  2011/08/18 23:27:54  pauloscustodio
* BUG_0009 : file read/write not tested for errors
* - In case of disk full file write fails, but assembler does not detect the error
*   and leaves back corruped object/binary files
* - Created new exception FileIOException and ERR_FILE_IO error.
* - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
* 
* Revision 1.16  2011/08/14 19:37:43  pauloscustodio
* Z80pass1(): no need to check for fatal error and return; bypassed by exception mechanism
* 
* Revision 1.15  2011/08/05 20:20:45  pauloscustodio
* CH_0004 : Exception mechanism to handle fatal errors
* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
* removing all the test code after each memory allocation.
* Replaced all functions that allocated memory structures by the new xcalloc_struct().
* Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
* Created try/catch sequences to clean-up partially created memory structures and rethrow the
* exception, to cleanup memory leaks.
* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
* 
* Revision 1.14  2011/07/18 00:48:25  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
* 
* Revision 1.13  2011/07/14 01:32:08  pauloscustodio
*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
*     CH_0003 : Error messages should be more informative
*         - Added printf-args to error messages, added "Error:" prefix.
*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
*         - Raise ERR_UNBALANCED_PAREN instead
* 
* Revision 1.12  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
* 
* Revision 1.11  2011/07/11 16:19:37  pauloscustodio
* Moved all option variables and option handling code to a separate module options.c,
* replaced all extern declarations of these variables by include options.h.
* Created declarations in z80asm.h of objects defined in z80asm.c.
* 
* Revision 1.10  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
* 
* Revision 1.9  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
* 
* Revision 1.8  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
* 
* Revision 1.7  2011/07/09 01:34:12  pauloscustodio
* added casts to clean up warnings
* BUG_0004 : 8bit unsigned constants are not checked for out-of-range
*      Added the check to ExprUnsigned8() and Z80pass2().
* 
* Revision 1.6  2010/04/16 17:34:37  dom
* Make line number an int - 32768 lines isn't big enough...
* 
* Revision 1.5  2009/09/03 17:54:55  dom
* Fix name conflict with the getline function in POSIX 2008
* 
* Nabbed via Fedora/Kevin Kofler
* 
* Revision 1.4  2009/08/14 22:23:12  dom
* clean up some compiler warnings
* 
* Revision 1.3  2002/05/11 20:09:38  dom
* A patch around the appalling IF ELSE ENDIF handling of z80asm where it
* tries to evaluate FALSE clauses and gets completely in a twist.
* 
* These patches turn off the output to the two errors that I've seen pop
* up in this state: Syntax error and unknown identifier. Please test this
* one quite hard if you get a change... - it was done to allow even more
* complicated logic in the z88 app startup to actually work - as soon as I'm
* happy with that I'll commit it as well
* 
* Revision 1.2  2001/03/21 16:34:01  dom
* Added changes to allow labels to end in ':' and the prefix '.' isn't
* necessarily needed..this isn't guaranteed to be perfect so let me know
* of any problems and drop back to 1.0.18
* 
* Revision 1.1  2000/07/04 15:33:29  dom
* branches:  1.1.1;
* Initial revision
* 
* Revision 1.1.1.1  2000/07/04 15:33:29  dom
* First import of z88dk into the sourceforge system <gulp>
* 
*/

/* $History: Z80PASS.C $ */
/*  */
/* *****************  Version 14  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 12  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:39 */
/* Updated in $/Z80asm */
/* parseline() bug fix: code size may reach <= MAXCODESIZE. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:06 */
/* Updated in $/Z80asm */
/* New function, Flncmp() to compare two filenames after internal lower */
/* case conversion (used by Include file mutual recursion validation). */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:16 */
/* Updated in $/Z80asm */
/* New function, FindFile(), to validate whether an include file already */
/* has been included in a previous include level. */
/* Z80pass2() bug fix: Expressions that are saved to object file */
/* (typically containing external symbols) shouldn't get evaluated - this */
/* can create unnecessary error messages. */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */
