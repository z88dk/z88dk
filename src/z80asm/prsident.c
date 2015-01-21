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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsident.c,v 1.113 2015-01-21 23:34:54 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "scan.h"
#include "parse.h"
#include "symbol.h"
#include "symtab.h"
#include "types.h"
#include "z80asm.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
void DEFINE( void );
void ifstatement(ParseCtx *ctx, Bool compile_active);
void ifdefstatement(ParseCtx *ctx, Bool compile_active);
void ifndefstatement(ParseCtx *ctx, Bool compile_active);
void CALL_OZ(void), OZ(void), CALL_PKG(void), FPP(void);
void INVOKE( void );
void DEFB( void ), DEFC( void ), DEFM( void ), DEFW( void ), DEFL( void ), DEFP( void );
void UNDEFINE( void );


/* local functions */
void ParseIdent(ParseCtx *ctx, Bool compile_active);
void IF(void), IFDEF(void), IFNDEF(void), ELSE(void), ENDIF(void);



typedef void ( *ptrfunc )( void ); /* ptr to function returning void */
typedef int ( *fptr )( const void *, const void * );

struct Z80sym
{
    char *z80mnem;
    ptrfunc z80func;
};


#define DEF_ENTRY(func)     { #func, func }
struct Z80sym Z80ident[] =
{
    DEF_ENTRY( CALL_OZ ),
    DEF_ENTRY( CALL_PKG ),
    DEF_ENTRY( DEFB ),
    DEF_ENTRY( DEFC ),
    DEF_ENTRY( DEFINE ),
    DEF_ENTRY( DEFL ),
    DEF_ENTRY( DEFM ),
    DEF_ENTRY( DEFP ),
    DEF_ENTRY( DEFW ),
    DEF_ENTRY( ELSE ),
    DEF_ENTRY( ENDIF ),
    DEF_ENTRY( FPP ),
	DEF_ENTRY( IF ),
	DEF_ENTRY( IFDEF ),
	DEF_ENTRY( IFNDEF ),
	DEF_ENTRY( INVOKE ),
    DEF_ENTRY( OZ ),
    DEF_ENTRY( UNDEFINE ),
};
#undef DEF_ENTRY

int
idcmp( char *idptr, const struct Z80sym *symptr )
{
    return stricompare( idptr, symptr->z80mnem );
}


struct Z80sym *SearchId( void )
{
    struct Z80sym *foundsym;

    foundsym = ( struct Z80sym * ) bsearch(sym_text(&sym), Z80ident, NUM_ELEMS( Z80ident ), sizeof( struct Z80sym ),
                                            ( fptr ) idcmp );
    return foundsym;
}



void
ParseIdent(ParseCtx *ctx, Bool compile_active)
{
    struct Z80sym *foundsym;

    foundsym = SearchId();

    if ( foundsym == NULL )
    {
        if ( compile_active )      /* only issue error message if interpreting */
			error_syntax();
            //error_unknown_ident();
    }
    else
    {
		if (foundsym->z80func == IF)
		{
			if (! compile_active)
				Skipline();    /* skip current line until EOL */

			ifstatement(ctx, compile_active);
		}
		else if (foundsym->z80func == IFDEF)
		{
			if (! compile_active)
				Skipline();    /* skip current line until EOL */

			ifdefstatement(ctx, compile_active);
		}
		else if (foundsym->z80func == IFNDEF)
		{
			if (! compile_active)
				Skipline();    /* skip current line until EOL */

			ifndefstatement(ctx, compile_active);
		}
		else if (foundsym->z80func == ELSE ||
                  foundsym->z80func == ENDIF )
        {
            ( foundsym->z80func )();
            Skipline();
        }
        else
        {
            if ( compile_active )
                ( foundsym->z80func )();

            Skipline();               /* skip current line until EOL */
        }
    }
}



/* dummy function - not used */
void
IF(void)
{
}

/* dummy function - not used */
void
IFDEF(void)
{
}

/* dummy function - not used */
void
IFNDEF(void)
{
}




void
ELSE( void )
{
    sym.tok = TK_ELSE_STMT;
}




void
ENDIF( void )
{
    sym.tok = TK_ENDIF_STMT;
}
