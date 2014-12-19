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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsident.c,v 1.84 2014-12-19 21:21:08 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "scan.h"
#include "symbol.h"
#include "symtab.h"
#include "types.h"
#include "z80asm.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
void Subroutine_addr( int opc0, int opc );
void JP_instr( int opc0, int opc );
void PushPop_instr( int opcode );
void RotShift_instr( int opcode );
void BitTest_instr( int opcode );
void ArithLog8_instr( int opcode );
void DeclModuleName( void );
void DEFINE( void );
void ifstatement(enum flag interpret);
void ifdefstatement(enum flag interpret);
void ifndefstatement(enum flag interpret);
void DEFVARS(void), DEFS(void), ORG(void), INCLUDE(void), BINARY(void), CALL_OZ(void), OZ(void), CALL_PKG(void), FPP(void);
void ADC( void ), ADD( void ), DEC( void ), IN( void ), INC( void ), INVOKE( void );
void JR( void ), LD( void ), OUT( void ), RET( void ), SBC( void );
void DEFB( void ), DEFC( void ), DEFM( void ), DEFW( void ), DEFL( void ), DEFP( void );
void RST( void ), DEFGROUP( void );
void UNDEFINE( void );


/* local functions */
void ParseIdent( enum flag interpret );
void AND( void ), BIT( void ), CALL( void ), CP( void ), CPD( void );
void CPDR( void ), CPI( void ), CPIR( void ), DAA( void );
void DI( void ), DJNZ( void );
void EI( void ), EX( void );
void IND( void );
void INDR( void ), INI( void ), INIR( void ), JP( void );
void LDD( void ), LDDR( void );
void LDI( void ), LDIR( void ), OR( void ), OTDR( void ), OTIR( void );
void OUTD( void ), OUTI( void ), POP( void ), PUSH( void ), RES( void );
void RETI( void ), RETN( void );
void RL( void ), RLA( void ), RLC( void ), RLCA( void ), RLD( void ), RR( void ), RRA( void ), RRC( void );
void RRCA( void ), RRD( void );
void SCF( void ), SET( void ), SLA( void ), SLL( void ), SRA( void );
void SRL( void ), SUB( void ), XOR( void );
void XREF( void ), XDEF( void ), LSTON( void ), LSTOFF( void );
void LIB( void ), XLIB( void );
void IF(void), IFDEF(void), IFNDEF(void), ELSE(void), ENDIF(void);
void MODULE( void );
void SECTION( void );
void LINE( void );
void PUBLIC( void ); void EXTERN( void ); 


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
    DEF_ENTRY( ADC ),
    DEF_ENTRY( ADD ),
    DEF_ENTRY( AND ),
    DEF_ENTRY( BINARY ),
    DEF_ENTRY( BIT ),
    DEF_ENTRY( CALL ),
    DEF_ENTRY( CALL_OZ ),
    DEF_ENTRY( CALL_PKG ),
    DEF_ENTRY( CP ),
    DEF_ENTRY( CPD ),
    DEF_ENTRY( CPDR ),
    DEF_ENTRY( CPI ),
    DEF_ENTRY( CPIR ),
    DEF_ENTRY( DAA ),
    DEF_ENTRY( DEC ),
    DEF_ENTRY( DEFB ),
    DEF_ENTRY( DEFC ),
    DEF_ENTRY( DEFGROUP ),
    DEF_ENTRY( DEFINE ),
    DEF_ENTRY( DEFL ),
    DEF_ENTRY( DEFM ),
    DEF_ENTRY( DEFP ),
    DEF_ENTRY( DEFS ),
    DEF_ENTRY( DEFVARS ),
    DEF_ENTRY( DEFW ),
    DEF_ENTRY( DI ),
    DEF_ENTRY( DJNZ ),
    DEF_ENTRY( EI ),
    DEF_ENTRY( ELSE ),
    DEF_ENTRY( ENDIF ),
    DEF_ENTRY( EX ),
    DEF_ENTRY( EXTERN ),
    DEF_ENTRY( FPP ),
	DEF_ENTRY( IF ),
	DEF_ENTRY( IFDEF ),
	DEF_ENTRY( IFNDEF ),
	DEF_ENTRY( IN ),
    DEF_ENTRY( INC ),
    DEF_ENTRY( INCLUDE ),
    DEF_ENTRY( IND ),
    DEF_ENTRY( INDR ),
    DEF_ENTRY( INI ),
    DEF_ENTRY( INIR ),
    DEF_ENTRY( INVOKE ),
    DEF_ENTRY( JP ),
    DEF_ENTRY( JR ),
    DEF_ENTRY( LD ),
    DEF_ENTRY( LDD ),
    DEF_ENTRY( LDDR ),
    DEF_ENTRY( LDI ),
    DEF_ENTRY( LDIR ),
    DEF_ENTRY( LIB ),
    DEF_ENTRY( LINE ),
    DEF_ENTRY( LSTOFF ),
    DEF_ENTRY( LSTON ),
    DEF_ENTRY( MODULE ),
    DEF_ENTRY( OR ),
    DEF_ENTRY( ORG ),
    DEF_ENTRY( OTDR ),
    DEF_ENTRY( OTIR ),
    DEF_ENTRY( OUT ),
    DEF_ENTRY( OUTD ),
    DEF_ENTRY( OUTI ),
    DEF_ENTRY( OZ ),
    DEF_ENTRY( POP ),
    DEF_ENTRY( PUBLIC ),
    DEF_ENTRY( PUSH ),
    DEF_ENTRY( RES ),
    DEF_ENTRY( RET ),
    DEF_ENTRY( RETI ),
    DEF_ENTRY( RETN ),
    DEF_ENTRY( RL ),
    DEF_ENTRY( RLA ),
    DEF_ENTRY( RLC ),
    DEF_ENTRY( RLCA ),
    DEF_ENTRY( RLD ),
    DEF_ENTRY( RR ),
    DEF_ENTRY( RRA ),
    DEF_ENTRY( RRC ),
    DEF_ENTRY( RRCA ),
    DEF_ENTRY( RRD ),
    DEF_ENTRY( RST ),
    DEF_ENTRY( SBC ),
    DEF_ENTRY( SCF ),
    DEF_ENTRY( SECTION ),
    DEF_ENTRY( SET ),
    DEF_ENTRY( SLA ),
    DEF_ENTRY( SLL ),
    DEF_ENTRY( SRA ),
    DEF_ENTRY( SRL ),
    DEF_ENTRY( SUB ),
    DEF_ENTRY( UNDEFINE ),
    DEF_ENTRY( XDEF ),
    DEF_ENTRY( XLIB ),
    DEF_ENTRY( XOR ),
    DEF_ENTRY( XREF )
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

    foundsym = ( struct Z80sym * ) bsearch( sym.string, Z80ident, NUM_ELEMS( Z80ident ), sizeof( struct Z80sym ),
                                            ( fptr ) idcmp );
    return foundsym;
}



void
ParseIdent( enum flag interpret )
{
    struct Z80sym *foundsym;

    foundsym = SearchId();

    if ( foundsym == NULL )
    {
        if ( interpret == ON )      /* only issue error message if interpreting */
            error_unknown_ident();
    }
    else
    {
		if (foundsym->z80func == IF)
		{
			if (interpret == OFF)
				Skipline();    /* skip current line until EOL */

			ifstatement(interpret);
		}
		else if (foundsym->z80func == IFDEF)
		{
			if (interpret == OFF)
				Skipline();    /* skip current line until EOL */

			ifdefstatement(interpret);
		}
		else if (foundsym->z80func == IFNDEF)
		{
			if (interpret == OFF)
				Skipline();    /* skip current line until EOL */

			ifndefstatement(interpret);
		}
		else if (foundsym->z80func == ELSE ||
                  foundsym->z80func == ENDIF )
        {
            ( foundsym->z80func )();
            Skipline();
        }
        else
        {
            if ( interpret == ON )
                ( foundsym->z80func )();

            Skipline();               /* skip current line until EOL */
        }
    }
}



void
LSTON( void )
{
    if ( opts.list )
        opts.cur_list = TRUE;				/* switch listing ON again... */
}



void
LSTOFF( void )
{
    if ( opts.list )
        opts.cur_list = FALSE;
}

/* Function for Line number in C source */
void LINE( void )
{
	DEFINE_STR( name, MAXLINE );

    GetSym();
	if (sym.tok != TK_NUMBER)
		error_syntax();

    if ( opts.line_mode )
        set_error_line( sym.number );

	Str_sprintf( name, "__C_LINE_%ld", sym.number );
    define_symbol( name->str, get_PC(), TYPE_ADDRESS, SYM_TOUCHED );
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


void
PUBLIC( void )
{
    do
    {
        if ( GetSym() == TK_NAME )
        {
            declare_public_symbol( sym.string );
        }
        else
        {
            error_syntax();
            return;
        }
    }
    while ( GetSym() == TK_COMMA );

    if ( sym.tok != TK_NEWLINE && sym.tok != TK_END )
    {
		error_syntax();
    }
}

void
XDEF( void )
{
#if 0
	warn_deprecated("XDEF", "PUBLIC");
#endif
	PUBLIC();
}

void
XLIB( void )
{
#if 0
	warn_deprecated("XLIB", "PUBLIC");
#endif
	PUBLIC();
}

void
EXTERN( void )
{
    do
    {
        if ( GetSym() == TK_NAME )
        {
            declare_extern_symbol( sym.string );    /* Define symbol as extern */
        }
        else
        {
			error_syntax();
            return;
        }
    }
    while ( GetSym() == TK_COMMA );

    if ( sym.tok != TK_NEWLINE && sym.tok != TK_END )
    {
		error_syntax();
    }
}

void
XREF( void )
{
#if 0
	warn_deprecated("XREF", "EXTERN");
#endif
	EXTERN();
}

void
LIB( void )
{
#if 0
	warn_deprecated("LIB", "EXTERN");
#endif
	EXTERN();
}


void
MODULE( void )
{
    if ( opts.force_xlib )
    {
        PUBLIC();
    }
    else
    {
        GetSym();
        DeclModuleName();
    }
}


void
SECTION( void )
{
    GetSym();
	if ( sym.tok == TK_NAME )
		new_section( sym.string );
	else
		error_syntax();
}


void
LDI( void )
{
    append_2bytes( 0xED, 0xA0 );
}



void
LDIR( void )
{
    append_2bytes( 0xED, 0xB0 );
}



void
LDD( void )
{
    append_2bytes( 0xED, 0xA8 );
}



void
LDDR( void )
{
    append_2bytes( 0xED, 0xB8 );
}



void
CPI( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        SetTemporaryLine( "\n extern rcmx_cpi \n call rcmx_cpi \n" );
        return;
    }

    append_2bytes( 0xED, 0xA1 );
}



void
CPIR( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        SetTemporaryLine( "\n extern rcmx_cpir \n call rcmx_cpir \n" );
        return;
    }

    append_2bytes( 0xED, 0xB1 );
}



void
CPD( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        SetTemporaryLine( "\n extern rcmx_cpd \n call rcmx_cpd \n" );
        return;
    }

    append_2bytes( 0xED, 0xA9 );
}



void
CPDR( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        SetTemporaryLine( "\n extern rcmx_cpdr \n call rcmx_cpdr \n" );
        return;
    }

    append_2bytes( 0xED, 0xB9 );
}



void
IND( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xAA );
}



void
INDR( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xBA );
}



void
INI( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xA2 );
}



void
INIR( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xB2 );
}



void
OUTI( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xA3 );
}



void
OUTD( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xAB );
}



void
OTIR( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xB3 );
}



void
OTDR( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0xBB );
}




/*
 * Allow specification of "<instr> [A,]xxx"
 * in SUB, AND, OR, XOR, CP instructions
 */
void
ExtAccumulator( int opcode )
{
	if (sym.tok == TK_A)
	{
		GetSym();
		if (sym.tok == TK_COMMA)
			GetSym();
		else
		{
			sym.tok = TK_A;				/* push back 'A' */
			sym.cpu_reg8 = REG8_A;
		}
	}
	ArithLog8_instr(opcode);
}



void
CP( void )
{
	GetSym();
	ExtAccumulator(7);
}




void
AND( void )
{
	GetSym();
	ExtAccumulator(4);
}



void
OR( void )
{
	GetSym();
	ExtAccumulator(6);
}



void
XOR( void )
{
	GetSym();
	ExtAccumulator(5);
}


void
SUB( void )
{
	GetSym();
	ExtAccumulator(2);
}




void
SET( void )
{
    BitTest_instr( 192 );
}



void
RES( void )
{
    BitTest_instr( 128 );
}



void
BIT( void )
{
    BitTest_instr( 64 );
}



void
RLC( void )
{
    RotShift_instr( 0 );
}



void
RRC( void )
{
    RotShift_instr( 1 );
}



void
RL( void )
{
    RotShift_instr( 2 );
}



void
RR( void )
{
    RotShift_instr( 3 );
}



void
SLA( void )
{
    RotShift_instr( 4 );
}



void
SRA( void )
{
    RotShift_instr( 5 );
}



void
SLL( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    RotShift_instr( 6 );
}



void
SRL( void )
{
    RotShift_instr( 7 );
}



void
RLA( void )
{
    append_byte( 0x17 );
}



void
RRA( void )
{
    append_byte( 0x1F );
}



void
RRCA( void )
{
    append_byte( 0x0F );
}



void
RLCA( void )
{
    append_byte( 0x07 );
}



void
PUSH( void )
{
    PushPop_instr( 197 );
}



void
POP( void )
{
    PushPop_instr( 193 );
}




void
RETI( void )
{
    append_2bytes( 0xED, 0x4D );
}



void
RETN( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_2bytes( 0xED, 0x45 );
}



void
RLD( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        SetTemporaryLine( "\n extern rcmx_rld \n call rcmx_rld \n" );
        return;
    }

    append_2bytes( 0xED, 0x6F );
}



void
RRD( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
        SetTemporaryLine( "\n extern rcmx_rrd \n call rcmx_rrd \n" );
        return;
    }

    append_2bytes( 0xED, 0x67 );
}



void
CALL( void )
{
	GetSym();
    Subroutine_addr( 205, 196 );
}



void
JP( void )
{
    JP_instr( 195, 194 );
}



void
SCF( void )
{
    append_byte( 0x37 );
}



void
DI( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_byte( 0xF3 );
}



void
EI( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_byte( 0xFB );
}



void
DAA( void )
{
    if ( ( opts.cpu & CPU_RABBIT ) )
    {
		error_illegal_ident();
        return;
    }

    append_byte( 0x27 );
}
