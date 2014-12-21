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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/asmdrctv.c,v 1.109 2014-12-21 17:20:54 pauloscustodio Exp $
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
struct sourcefile *Newfile( struct sourcefile *curfile, char *fname );
struct sourcefile *Prevfile( void );
struct sourcefile *FindFile( struct sourcefile *srcfile, char *fname );


/* local functions */
void DeclModuleName( void );
void DEFINE( void );
void UNDEFINE( void );


/* global variables */
extern UInt DEFVPC;


long
Parsevarsize( void )
{
    long offset = 0, varsize, size_multiplier;

	if (!sym.ds_size)
	{
		varsize = 0;
	}
	else
	{
		varsize = sym.ds_size;
		GetSym();

		if (expr_parse_eval(&size_multiplier))		/* error in expr_parse_eval() if failed */
		{
			if (size_multiplier > 0 && varsize * size_multiplier <= 0x10000)
			{
				offset = varsize * size_multiplier;
			}
			else
			{
				error_int_range(size_multiplier);
			}
		}
	}

    return offset;
}



long
Parsedefvarsize( long offset )
{
    long varoffset = 0;

	if (sym.tok == TK_NAME)
	{
		define_symbol(sym.string, offset, TYPE_CONSTANT, 0);
		GetSym();
	}

	varoffset = Parsevarsize();

    return varoffset;
}



void
DEFVARS( void )
{
    long offset;
    enum flag globaldefv;

    GetSym();
	if (!expr_parse_eval(&offset))
		return;

    if ( ( offset != -1 ) && ( offset != 0 ) )
    {
        DEFVPC = (UInt)offset;
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

    while ( sym.tok != TK_END && sym.tok != TK_LCURLY )
    {
        Skipline();

        EOL = FALSE;
        GetSym();
    }

    if ( sym.tok == TK_LCURLY )
    {
        while ( sym.tok != TK_END && GetSym() != TK_RCURLY )
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
            DEFVPC = (UInt)offset;
        }
    }
}



void
DEFGROUP( void )
{
    Expr *expr;
    long constant, enumconst = 0;
	DEFINE_STR( name, MAXLINE );

    while ( sym.tok != TK_END && GetSym() != TK_LCURLY )
    {
        Skipline();
        EOL = FALSE;
    }

    if ( sym.tok == TK_LCURLY )
    {
        while ( sym.tok != TK_END && sym.tok != TK_RCURLY )
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

                    switch ( sym.tok )
                    {
                    case TK_RCURLY:
                    case TK_NEWLINE:
                        break;

                    case TK_NAME:
						Str_set( name, sym.string );     /* remember name */

                        if ( GetSym() == TK_EQUAL )
                        {
                            GetSym();

                            if ( ( expr = expr_parse() ) != NULL )
                            {
                                if ( expr->result.not_evaluable )
                                {
                                    error_not_defined();
                                }
                                else
                                {
                                    constant = Expr_eval( expr );
                                    enumconst = constant;
                                    define_symbol( name->str, enumconst++, TYPE_CONSTANT, 0 );
                                }

                                OBJ_DELETE( expr );
                            }

                            /* BUG_0032 - removed: GetSym(); */
                        }
                        else
                        {
                            define_symbol( name->str, enumconst++, TYPE_CONSTANT, 0 );
                        }

                        break;

                    default:
						error_syntax();
                        break;
                    }
                }
                while ( sym.tok == TK_COMMA );   /* get enum definitions separated by comma in current line */

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
        if ( expr->result.not_evaluable )
        {
            /* BUG_0007 : memory leaks - was not being released in case of error */
            OBJ_DELETE( expr ); /* remove linked list, expression evaluated */
            error_not_defined();
        }
        else
        {
            constant = Expr_eval( expr );
            OBJ_DELETE( expr ); /* remove linked list, expression evaluated */

            if ( sym.tok != TK_COMMA )
            {
                val = 0;
            }
            else
            {
                GetSym();

                if ( ( constexpr = expr_parse() ) != NULL )
                {
                    if ( constexpr->result.not_evaluable )
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
            tok = find_local_symbol( sym.string );
        }

        if ( tok != NULL )
        {
            SymbolHash_remove( CURRENTMODULE->local_symtab, sym.string );
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
            define_local_def_sym( sym.string, 1 );
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
			Str_set( name, sym.string ); /* remember name */

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
ORG( void )
{
	long origin;

    GetSym();								/* get numerical expression */
	if (!expr_parse_eval(&origin))
		return;

	if (CURRENTSECTION->origin_found)
		error_org_redefined();
	else
	{
		CURRENTSECTION->origin_found = TRUE;
		if (origin == -1)					/* signal split section binary file */
			CURRENTSECTION->section_split = TRUE;
		else if (origin >= 0 && origin <= 0xFFFF)
		{
			if (CURRENTSECTION->origin_opts && CURRENTSECTION->origin >= 0)
				; /* ignore ORG, as --origin from command line overrides */
			else
				CURRENTSECTION->origin = origin;
		}
		else
			error_int_range(origin);
	}
}


void
DEFB( void )
{
    long bytepos = 0;

    do
    {
        GetSym();

		if (!Pass2info(RANGE_BYTE_UNSIGNED, bytepos))
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos++;

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
    long bytepos = 0;

    do
    {
        GetSym();

		if (!Pass2info(RANGE_WORD, bytepos))
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos += 2;

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
    long bytepos = 0;

    do
    {
        GetSym();

		if (!Pass2info(RANGE_WORD, bytepos))
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos += 2;

        /* Pointers must be specified as WORD,BYTE pairs separated by commas */
        if ( sym.tok != TK_COMMA )
        {
			error_syntax();
        }

        GetSym();

		if (!Pass2info(RANGE_BYTE_UNSIGNED, bytepos))
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos++;

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
    long bytepos = 0;

    do
    {
        GetSym();

		if (!Pass2info(RANGE_DWORD, bytepos))
        {
            break;    /* syntax error - get next line from file... */
        }

        bytepos += 4;

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
    long bytepos = 0;
	char *p;

    do
    {
        if ( GetSym() == TK_STRING )
        {
			for ( p = sym.string; *p != '\0'; p++ )
			{
                append_byte( (Byte) *p );
                ++bytepos;
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
			if (!Pass2info(RANGE_BYTE_UNSIGNED, bytepos))
            {
                break;    /* syntax error - get next line from file... */
            }

            if ( sym.tok != TK_STRING_CAT && sym.tok != TK_COMMA && sym.tok != TK_NEWLINE && sym.tok != TK_END)
            {
                error_syntax(); /* expression separator not found */
                break;
            }

            ++bytepos;
        }
    }
    while ( sym.tok != TK_NEWLINE && sym.tok != TK_END );
}




void
INCLUDE( void )
{
    if ( GetSym() == TK_STRING )
    {
        Z80pass1( sym.string );				/* parse include file */
    }
    else
    {
		error_syntax();
    }

    sym.tok = TK_NEWLINE;
}


void
BINARY( void )
{
    char      *filename;
    FILE          *binfile;

    if ( GetSym() == TK_STRING )
    {
        filename = search_file( sym.string, opts.inc_path );

        binfile = xfopen( filename, "rb" );           /* CH_0012 */
        append_file_contents( binfile, -1 );  /* read binary code */
        xfclose( binfile );
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
        if ( sym.tok == TK_NAME )
        {
            CURRENTMODULE->modname = strpool_add( sym.string );
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
