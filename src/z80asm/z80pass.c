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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80pass.c,v 1.115 2014-12-13 00:49:45 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "hist.h"
#include "listfile.h"
#include "model.h"
#include "modlink.h"
#include "options.h"
#include "parse.h"
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
		sym.tok = TK_NIL;
		while ( sym.tok != TK_END )
			parseline( ON );              /* before parsing it */
	}
	src_pop();
}



void
parseline( enum flag interpret )
{
    next_PC();				/* update assembler program counter */
	EOL = FALSE;			/* reset END OF LINE flag */

	scan_error = FALSE;		/* detect errors in GetSym() */
	GetSym();

	if (scan_error)
		Skipline();
	else if (!parse_statement(interpret))
	{
		/* scan error reported during parse_statement() */
		if (scan_error)
		{
			Skipline();
		}
		else
		{
			if (sym.tok == TK_DOT || sym.tok == TK_LABEL)
			{
				if (interpret == ON)
				{
					/* Generate only possible label declaration if line parsing is allowed */
					if (sym.tok == TK_LABEL || GetSym() == TK_NAME)
					{
						/* labels must always be touched due to forward referencing problems in expressions */
						define_symbol(sym.string, get_PC(), TYPE_ADDRESS, SYM_TOUCHED);

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
					sym.tok = TK_NEWLINE;    /* ignore label and rest of line */
				}
			}

			switch (sym.tok)
			{
			case TK_NAME:
				ParseIdent(interpret);
				break;

			case TK_END:
			case TK_NEWLINE:
				break;                /* empty line, get next... */

			default:
				if (interpret == ON)
				{
					error_syntax();    /* Syntax error */
					Skipline();
				}
			}
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
                if ( sym.tok != TK_END )
                {
                    parseline( ON );
                }
                else
                {
                    return;    /* end of file - exit from this #if level */
                }
            }
            while ( ( sym.tok != TK_ELSE_STMT ) && ( sym.tok != TK_ENDIF_STMT ) );

            if ( sym.tok == TK_ELSE_STMT )
            {
                do
                {
                    /* then ignore lines until #endif ... */
                    if ( sym.tok != TK_END )
                    {
                        parseline( OFF );
                    }
                    else
                    {
                        return;
                    }
                }
                while ( sym.tok != TK_ENDIF_STMT );
            }
        }
        else
        {
            do
            {
                /* expression is FALSE, ignore until #else or #endif */
                if ( sym.tok != TK_END )
                {
                    parseline( OFF );
                }
                else
                {
                    return;
                }
            }
            while ( ( sym.tok != TK_ELSE_STMT ) && ( sym.tok != TK_ENDIF_STMT ) );

            if ( sym.tok == TK_ELSE_STMT )
            {
                do
                {
                    if ( sym.tok != TK_END )
                    {
                        parseline( ON );
                    }
                    else
                    {
                        return;
                    }
                }
                while ( sym.tok != TK_ENDIF_STMT );
            }
        }
    }
    else
    {
        do
        {
            /* don't evaluate #if expression and ignore all lines until #endif */
            if ( sym.tok != TK_END )
            {
                parseline( OFF );
            }
            else
            {
                return;    /* end of file - exit from this IF level */
            }
        }
        while ( sym.tok != TK_ENDIF_STMT );
    }

    sym.tok = TK_NIL;
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
    Expr *expr, *expr2;
    long value;
    UInt patchptr;
	Bool do_patch, do_store;

	/* compute all dependent expressions */
	compute_equ_exprs( CURRENTMODULE->exprs, FALSE, TRUE );

	iter = ExprList_first( CURRENTMODULE->exprs );
	while ( iter != NULL )
	{
		expr = iter->obj;

        /* set error location */
		set_error_null();
        set_error_file( expr->filename );
        set_error_line( expr->line_nr );

		/* Define code location; BUG_0048 */
		set_cur_section( expr->section );
		set_PC( expr->asmpc );		

		/* try to evaluate expression to detect missing symbols */
		value = Expr_eval( expr );

		/* check if expression is stored in object file or computed and patched */
		do_patch = TRUE;
		do_store = FALSE;

		if ( expr->result.undefined_symbol ) 
		{
			error_not_defined();
			do_patch = FALSE;
		}
		else if ( expr->range == RANGE_JR_OFFSET )
		{
			if ( expr->result.extern_symbol )
			{
				error_jr_not_local();	/* JR must be local */
				do_patch = FALSE;
			}
		}
		else if ( ( (expr->sym_type >= TYPE_ADDRESS) || expr->result.extern_symbol ) )
		{
			do_patch = FALSE;
			do_store = TRUE;            /* store expression in relocatable file */
		}
		else if ( expr->result.not_evaluable )
		{
			error_not_defined();
			do_patch = FALSE;
		}

        if ( do_patch )
        {
            patchptr = expr->code_pos;            /* index in memory buffer */

            switch ( expr->range )
            {
            case RANGE_JR_OFFSET:
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

			case RANGE_BYTE_UNSIGNED:
                if ( value < -128 || value > 255 )
                    warn_int_range( value );

                patch_byte( &patchptr, (Byte) value );
                break;

            case RANGE_BYTE_SIGNED:
                if ( value < -128 || value > 127 )
                    warn_int_range( value );

                patch_byte( &patchptr, (Byte) value );
                break;

            case RANGE_WORD:
                if ( value < -32768 || value > 65535 )
                    warn_int_range( value );

                patch_word( &patchptr, ( int ) value );
                break;

            case RANGE_DWORD:
                if ( value < LONG_MIN || value > LONG_MAX )
                    warn_int_range( value );

                patch_long( &patchptr, value );
                break;

			default:
				assert(0);
            }
        }

		if ( opts.list )
			list_patch_data( expr->listpos, value, range_size( expr->range ) );
			
		/* continue loop - delete expression unless needs to be stored in object file */
		if ( do_store )
			iter = ExprList_next( iter );
		else
		{
			/* remove current expression, advance iterator */
			expr2 = ExprList_remove( CURRENTMODULE->exprs, &iter );
			assert( expr == expr2 );

			OBJ_DELETE( expr );	
		}
    }

    /* clean error location */
    set_error_null();
    //set_error_module( CURRENTMODULE->modname );

	/* create object file */
	if ( ! get_num_errors() )
		write_obj_file( CURRENTMODULE->filename );

    if ( ! get_num_errors() && opts.symtable )
    {
        WriteSymbolTable( "Local Module Symbols:", CURRENTMODULE->local_symtab );
        WriteSymbolTable( "Global Module Symbols:", global_symtab );
    }
}


Bool Pass2infoExpr(range_t range, int byteoffset, Expr *expr)
{
	int i;

	if (expr != NULL)
	{
		expr->range = range;
		expr->code_pos = get_cur_module_size();			/* update expression location */

		if (opts.cur_list)
			expr->listpos = list_patch_pos(byteoffset);	/* now calculated as absolute file pointer */
		else
			expr->listpos = -1;

		ExprList_push(&CURRENTMODULE->exprs, expr);
	}

	/* reserve space */
	for (i = 0; i < range_size(range); i++)
		append_byte(0);

	return expr == NULL ? FALSE : TRUE;
}

Bool Pass2info( range_t range,				/* allowed size of value to be parsed */
				int byteoffset )			/* position in listing file to patch */
{
	Expr *expr;
	
	/* Offset of (ix+d) should be optional; '+' or '-' are necessary */
	if (range == RANGE_BYTE_SIGNED)
	{
		switch (sym.tok)
		{
		case TK_RPAREN:
			append_byte(0);		/* offset zero */
			return TRUE;		/* OK, zero already stored */

		case TK_PLUS:
		case TK_MINUS:          /* + or - expected */
			break;				/* proceed to evaluate expression */

		default:                /* Syntax error, e.g. (ix 4) */
			error_syntax();
			return FALSE;		/* FAIL */
		}

	}

	expr = expr_parse();

	if (range == RANGE_BYTE_SIGNED && sym.tok != TK_RPAREN)
	{
		error_syntax();
		return FALSE;		/* FAIL */
	}

	return Pass2infoExpr(range, byteoffset, expr);
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

        if ( sym->module == CURRENTMODULE )
        {
            /* Write only symbols related to current module */
            if ( ( sym->sym_type_mask & SYM_LOCAL ) || ( sym->sym_type_mask & SYM_PUBLIC ) )
            {
                if ( ( sym->sym_type_mask & SYM_TOUCHED ) )
                {
                    list_symbol( sym->name, sym->value, sym->references );
                }
            }
        }

    }
}
