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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/asmdrctv.c,v 1.101 2014-06-23 22:27:09 pauloscustodio Exp $
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
extern UInt DEFVPC;


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

            if ( constant >= 0 && constant <= 0xFFFF )
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

    if ( GetSym() == TK_STRING )
    {
        filename = search_file( tok_string, opts.inc_path );

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
