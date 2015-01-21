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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/asmdrctv.c,v 1.118 2015-01-21 23:34:54 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include to enable memory leak detection */

#include "codearea.h"
#include "directives.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "listfile.h"
#include "legacy.h"
#include "expr_def.h"
#include "options.h"
#include "parse.h"
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
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
struct sourcefile *Prevfile( void );
struct sourcefile *FindFile( struct sourcefile *srcfile, char *fname );


/* local functions */
void DEFINE( void );
void UNDEFINE( void );


void
UNDEFINE( void )
{
    Symbol *tok = NULL;
	char *name;

    do
    {
        if ( GetSym() == TK_NAME )
        {
			name = sym_text(&sym);
			tok = find_local_symbol(name);
        }

        if ( tok != NULL )
        {
			SymbolHash_remove(CURRENTMODULE->local_symtab, name);
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
			define_local_def_sym(sym_text(&sym), 1);
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
			Str_set(name, sym_text(&sym)); /* remember name */

            if ( GetSym() == TK_EQUAL )
            {
                GetSym();         /* get numerical expression */

                if ( ( expr = expr_parse() ) != NULL )
                {
					if ( (expr->result.not_evaluable) || 
						 (expr->sym_type >= TYPE_ADDRESS) )
                    {
						/* store in object file to be computed at link time */
						expr->expr_type_mask |= RANGE_WORD;
						expr->target_name = strpool_add( name->str );

						ExprList_push( & CURRENTMODULE->exprs, expr );

						/* create symbol */
						define_symbol( expr->target_name, 0, TYPE_COMPUTED, 0 );
                    }
                    else
                    {
                        constant = Expr_eval( expr );    /* DEFC constant expression */
                        define_symbol( name->str, constant, TYPE_CONSTANT, 0 );
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
    while ( sym.tok == TK_COMMA );       /* get all DEFC definition separated by comma */
}



void
DEFB( void )
{
    do
    {
        GetSym();

		if (!Pass2info(RANGE_BYTE_UNSIGNED))
        {
            break;    /* syntax error - get next line from file... */
        }

        if ( sym.tok == TK_NEWLINE || sym.tok == TK_END )
        {
            break;
        }
        else if ( sym.tok != TK_COMMA )
        {
			error_syntax();
            break;
        }
    }
    while ( sym.tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFW( void )
{
    do
    {
        GetSym();

		if (!Pass2info(RANGE_WORD))
        {
            break;    /* syntax error - get next line from file... */
        }

        if ( sym.tok == TK_NEWLINE || sym.tok == TK_END )
        {
            break;
        }
        else if ( sym.tok != TK_COMMA )
        {
			error_syntax();
            break;
        }
    }
    while ( sym.tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFP( void )
{
    do
    {
        GetSym();

		if (!Pass2info(RANGE_WORD))
        {
            break;    /* syntax error - get next line from file... */
        }

        /* Pointers must be specified as WORD,BYTE pairs separated by commas */
        if ( sym.tok != TK_COMMA )
        {
			error_syntax();
        }

        GetSym();

		if (!Pass2info(RANGE_BYTE_UNSIGNED))
        {
            break;    /* syntax error - get next line from file... */
        }

        if ( sym.tok == TK_NEWLINE || sym.tok == TK_END )
        {
            break;
        }
        else if ( sym.tok != TK_COMMA )
        {
			error_syntax();
            break;
        }
    }
    while ( sym.tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFL( void )
{
    do
    {
        GetSym();

		if (!Pass2info(RANGE_DWORD))
        {
            break;    /* syntax error - get next line from file... */
        }

        if ( sym.tok == TK_NEWLINE || sym.tok == TK_END )
        {
            break;
        }
        else if ( sym.tok != TK_COMMA )
        {
			error_syntax();
            break;
        }
    }
    while ( sym.tok == TK_COMMA );       /* get all DEFB definitions separated by comma */
}



void
DEFM( void )
{
	char *p;

    do
    {
        if ( GetSym() == TK_STRING )
        {
			for (p = sym_text(&sym); *p != '\0'; p++)
			{
                append_byte( (Byte) *p );
			}

            GetSym();
            if ( sym.tok != TK_STRING_CAT && sym.tok != TK_COMMA && sym.tok != TK_NEWLINE && sym.tok != TK_END)
            {
				error_syntax();
                return;
            }
        }
        else
        {
			if (!Pass2info(RANGE_BYTE_UNSIGNED))
            {
                break;    /* syntax error - get next line from file... */
            }

            if ( sym.tok != TK_STRING_CAT && sym.tok != TK_COMMA && sym.tok != TK_NEWLINE && sym.tok != TK_END)
            {
                error_syntax(); /* expression separator not found */
                break;
            }
        }
    }
    while ( sym.tok != TK_NEWLINE && sym.tok != TK_END );
}
