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
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsline.c,v 1.26 2012-05-20 06:39:27 pauloscustodio Exp $ */
/* $Log: prsline.c,v $
/* Revision 1.26  2012-05-20 06:39:27  pauloscustodio
/* astyle
/*
/* Revision 1.25  2012/05/20 06:37:31  pauloscustodio
/* Comments on unreachable cases in GetSym()
/*
/* Revision 1.24  2012/05/20 05:31:18  pauloscustodio
/* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
/*
/* Revision 1.23  2012/05/12 16:54:49  pauloscustodio
/* temporary_start not used, removed
/*
/* Revision 1.22  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.21  2011/08/05 19:59:51  pauloscustodio
/* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
/*
/* Revision 1.20  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.19  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.18  2011/07/11 16:07:16  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/*
/* Revision 1.17  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.16  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.15  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.14  2011/07/09 01:23:13  pauloscustodio
/* BUG_0001 : Error in expression during link, expression garbled - memory corruption?
/*      Simple asm program: "org 0 \n jp NN \n jp NN \n NN: \n",
/*      compile with "z80asm -t4 -b test.asm"
/*      fails with: "File 'test.asm', Module 'TEST', Syntax error in expression \n
/*                   Error in expression +¶+≤+-;æ?.π“¶“≤Ÿ+v›F›V›^›x¶ ›@›H›P›".
/*      Problem cause: lexer GetSym() is not prepared to read '\0' bytes.
/*      When the expression is read from the OBJ file at the link phase, the '\0'
/*      at the end of the expression field is interpreted as a random separator
/*      because ssym[] contains fewer elements (27) than the separators string (28);
/*      hence in some cases the expression is parsed correctly, e.g. without -t4
/*      the program assembles correctly.
/*      If the random separator is a semicolon, GetSym() calls Skipline() to go past
/*      the comment, and reads past the end of the expression in the OBJ file,
/*      causing the parse of the next expression to fail.
/*
/* Revision 1.13  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/*
/* Revision 1.12  2009/08/14 22:23:12  dom
/* clean up some compiler warnings
/*
/* Revision 1.11  2009/07/18 23:23:15  dom
/* clean up the code a bit more (Formatting and a fewer magic numbers)
/*
/* Revision 1.10  2007/06/17 12:07:43  dom
/* Commit the rabbit emulation code including rrd, rld
/*
/* Add a .vcproj for visual studio
/*
/* Revision 1.9  2007/02/28 11:23:24  stefano
/* New platform !
/* Rabbit Control Module 2000/3000.
/*
/* Revision 1.8  2002/04/22 14:45:51  stefano
/* Removed the SLL L undocumented instructions from the Graph library.
/* NEW startup=2 mode for the ZX81 (SLOW mode... hoping we'll make it work in the future).
/* MS Visual C compiler related fixes
/* -IXIY option on Z80ASM to swap the IX and IY registers
/*
/* Revision 1.7  2002/01/18 21:12:17  dom
/* 0x prefix allowed for hex constants
/*
/* Revision 1.6  2002/01/18 16:55:40  dom
/* minor bug fix on the previous commit
/*
/* Revision 1.5  2002/01/18 16:53:13  dom
/* added 'd' and 'b' identifiers for constants - decimal and binary
/* respectively.
/*
/* Revision 1.4  2002/01/16 21:56:43  dom
/* we now accept h as a post modifier for hex numbers eg:
/*      ld      a,20h == ld a,$20 == ld a,32
/*
/* Revision 1.3  2001/04/11 09:48:18  dom
/* Minor fix to allow labels to end in ':'
/*
/* Revision 1.2  2001/03/21 16:34:01  dom
/* Added changes to allow labels to end in ':' and the prefix '.' isn't
/* necessarily needed..this isn't guaranteed to be perfect so let me know
/* of any problems and drop back to 1.0.18
/*
/* Revision 1.1  2000/07/04 15:33:30  dom
/* branches:  1.1.1;
/* Initial revision
/*
/* Revision 1.1.1.1  2000/07/04 15:33:30  dom
/* First import of z88dk into the sourceforge system <gulp>
/*
/* */

/* $History: PRSLINE.C $ */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:30 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
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
/* User: Gbs          Date: 20-06-98   Time: 15:02 */
/* Updated in $/Z80asm */
/* GetSym() and Skipline() improved with EOF handling. */


#include "memalloc.h"   /* before any other include to enable memory leak detection */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "config.h"
#include "z80asm.h"
#include "symbol.h"
#include "options.h"
#include "errors.h"

/* local functions */
long GetConstant( char *evalerr );
int IndirectRegisters( void );
int CheckRegister16( void );
int CheckRegister8( void );
int CheckCondition( void );
int GetChar( FILE *fptr );
enum symbols GetSym( void );
void Skipline( FILE *fptr );
int CheckBaseType( int chcount );

/* global variables */
extern FILE *z80asmfile;
extern char ident[];
extern char separators[];
extern enum symbols sym, ssym[];
extern int currentline;
extern struct module *CURRENTMODULE;
extern enum flag EOL;


char  *temporary_ptr = NULL;


void UnGet( int c, FILE *fp )
{
    if ( temporary_ptr )
    {
        temporary_ptr--;
    }
    else
    {
        ungetc( c, fp );
    }
}




void
SetTemporaryLine( char *line )
{
    temporary_ptr = line;
}

/* get a character from file with CR/LF/CRLF parsing capability.
 *
 * return '\n' byte if a CR/LF/CRLF variation line feed is found
 *
 */
int
GetChar( FILE *fptr )
{
    int c;

    if ( temporary_ptr != NULL )
    {
        if ( *temporary_ptr != 0 )
        {
            c = *temporary_ptr++;
            return c;
        }

        temporary_ptr = NULL;
    }


    c = fgetc( fptr );

    if ( c == 13 )
    {
        /* Mac/Z88 line feed found,poll for MSDOS line feed */
        c = fgetc( fptr );

        if ( c != 10 )
        {
            ungetc( c, fptr );    /* push non-line-feed character back into file stream */
        }

        c = '\n'; /* always return the symbolic '\n' for line feed */
    }
    else if ( c == 10 )
    {
        c = '\n';    /* UNIX/QDOS line feed */
    }

    return c;     /* return all other characters */
}


enum symbols
GetSym( void )
{
    char *instr;
    int c, chcount = 0;

    ident[0] = '\0';

    if ( EOL == ON )
    {
        sym = newline;
        return sym;
    }

    for ( ;; )
    {
        /* Ignore leading white spaces, if any... */
        if ( feof( z80asmfile ) )
        {
            sym = newline;
            EOL = ON;
            return newline;
        }
        else
        {
            c = GetChar( z80asmfile );

            if ( ( c == '\n' ) || ( c == EOF ) || ( c == '\x1A' )
                    || ( c == '\0' ) )        /* BUG_0001 Bugfix read overrun in OBJ file expression */
            {
                sym = newline;
                EOL = ON;
                return newline;
            }
            else if ( !isspace( c ) )
            {
                break;
            }
        }
    }

    instr = strchr( separators, c );

    if ( instr != NULL )
    {
        sym = ssym[instr - separators];   /* index of found char in separators[] */

        if ( sym == semicolon )
        {
            Skipline( z80asmfile );       /* ignore comment line, prepare for next line */
            sym = newline;
        }

        return sym;
    }

    ident[chcount++] = ( char ) toupper( c );

    switch ( c )
    {
        case '$':
            sym = hexconst;
            break;

        case '@':
        case '%':       /* not reached, as '%' is a separator */
            sym = binconst;
            break;

        case '#':       /* not reached, as '#' is a separator */
            sym = name;
            break;

        default:
            if ( isdigit( c ) )
            {
                sym = decmconst;      /* a decimal number found */
            }
            else
            {
                if ( isalpha( c ) || c == '_' )
                {
                    sym = name;       /* an identifier found */
                }
                else
                {
                    sym = nil;        /* rubbish ... */
                }
            }

            break;
    }

    /* Read identifier until space or legal separator is found */
    if ( sym == name )
    {
        for ( ;; )
        {
            if ( feof( z80asmfile ) )
            {
                break;
            }
            else
            {
                c = GetChar( z80asmfile );

                if ( ( c != EOF ) && ( !iscntrl( c ) ) && ( strchr( separators, c ) == NULL ) )
                {
                    if ( !isalnum( c ) )
                    {
                        if ( c != '_' )
                        {
                            sym = nil;
                            break;
                        }
                        else
                        {
                            ident[chcount++] = '_';       /* underscore in identifier */
                        }
                    }
                    else
                    {
                        ident[chcount++] = ( char ) toupper( c );
                    }
                }
                else
                {
                    if ( c != ':' )
                    {
                        UnGet( c, z80asmfile );    /* puch character back into stream for next read */
                    }
                    else
                    {
                        sym = label;
                    }

                    break;
                }
            }
        }

        chcount = CheckBaseType( chcount );
    }
    else
    {
        for ( ;; )
        {
            if ( feof( z80asmfile ) )
            {
                break;
            }
            else
            {
                c = GetChar( z80asmfile );

                if ( ( c != EOF ) && !iscntrl( c ) && ( strchr( separators, c ) == NULL ) )
                {
                    ident[chcount++] = c;
                }
                else
                {
                    UnGet( c, z80asmfile );       /* puch character back into stream for next read */
                    break;
                }
            }
        }

        chcount = CheckBaseType( chcount );
    }

    ident[chcount] = '\0';

    return sym;
}

int
CheckBaseType( int chcount )
{
    int   i;

    if ( !isxdigit( ident[0] ) || chcount < 2 )    /* If it's not a hex digit straight off then reject it */
    {
        return chcount;
    }

    /* C style hex number */
    if ( chcount > 2 && strncmp( ident, "0x", 2 ) == 0 )
    {
        for ( i = 2; i < chcount; i++ )
        {
            if ( !isxdigit( ident[i] ) )
            {
                break;
            }
        }

        if ( i == chcount )
        {
            for ( i = 2; i < chcount ; i++ )
            {
                ident[i - 1] = ident[i];
            }

            ident[0] = '$';
            sym = hexconst;
            return ( chcount - 1 );
        }
    }

    /* Check for this to be a hex num here */
    for ( i = 0; i <  chcount ; i++ )
    {
        if ( !isxdigit( ident[i] ) )
        {
            break;
        }
    }

    if ( i == ( chcount - 1 ) )
    {
        if ( toupper( ident[i] ) == 'H' )
        {
            for ( i = ( chcount - 1 ); i >= 0 ; i-- )
            {
                ident[i + 1] = ident[i];
            }

            ident[0] = '$';
            sym = hexconst;
            return chcount;
        }
        else
        {
            return chcount;      /* If we reached end of hex digits and the last one wasn't a 'h', then something is wrong, so return */
        }
    }

    /* Check for binary constant (ends in b) */
    for ( i = 0; i <  chcount ; i++ )
    {
        if ( ident[i] != '0' && ident[i] != '1' )
        {
            break;
        }
    }

    if ( i == ( chcount - 1 ) && toupper( ident[i] ) == 'B' )
    {
        for ( i = ( chcount - 1 ); i >= 0 ; i-- )
        {
            ident[i + 1] = ident[i];
        }

        ident[0] = '@';
        sym = binconst;
        return chcount;
    }

    /* Check for decimal (we default to it in anycase..but */
    for ( i = 0; i <  chcount ; i++ )
    {
        if ( !isdigit( ident[i] ) )
        {
            break;
        }
    }

    if ( i == ( chcount - 1 ) && toupper( ident[i] ) == 'D' )
    {
        sym = decmconst;
        return chcount - 1;
    }

    return chcount;
}





void
Skipline( FILE *fptr )
{
    int c;

    if ( EOL == OFF )
    {
        while ( !feof( fptr ) )
        {
            c = GetChar( fptr );

            if ( ( c == '\n' ) || ( c == EOF ) )
            {
                break;    /* get to beginning of next line... */
            }
        }

        EOL = ON;
    }
}


struct
{
    char          *name;
    int            flags;
    int            cpu;
}
flags[] =
{
    { "Z",    FLAGS_Z,  CPU_ALL },
    { "NZ",   FLAGS_NZ, CPU_ALL },
    { "C",    FLAGS_C,  CPU_ALL },
    { "NC",   FLAGS_NC, CPU_ALL },
    { "PE",   FLAGS_PE, CPU_ALL },   /* Not for jr, emu for RCM */
    { "PO",   FLAGS_PO, CPU_ALL },   /* Not for jr, emu for RCM */
    { "P",    FLAGS_P,  CPU_ALL },   /* Not for jr, emu for RCM */
    { "M",    FLAGS_M,  CPU_ALL },   /* Not for jr, emu for RCM */
#if 0
    { "LZ",   FLAGS_PO, CPU_RABBIT },  /* RCM alias */
    { "LO",   FLAGS_PE, CPU_RABBIT },  /* RCM alias */
    { "GTU",  FLAGS_GTU, CPU_RCM4000 }, /* RCM4000 */
    { "GT",   FLAGS_GT,  CPU_RCM4000 },  /* RCM4000 */
    { "LT",   FLAGS_LT,  CPU_RCM4000 },  /* RCM4000 */
    { "V",    FLAGS_V,   CPU_RCM4000 },   /* RCM4000 */
#endif
};



int
CheckCondition( void )
{
    int     i;
    char   *text = ident;
    size_t len = strlen( text );

    for ( i = 0; i < sizeof( flags ) / sizeof( flags[0] ); i++ )
    {
        if ( len != strlen( flags[i].name ) )
        {
            continue;
        }

        if ( strcmp( text, flags[i].name ) == 0 )
        {
            if ( ( cpu_type & flags[i].cpu ) == 0 )
            {
                continue;
            }

            return flags[i].flags;
        }
    }

    return -1;
}


int
CheckRegister8( void )
{
    if ( sym == name )
    {
        if ( *( ident + 1 ) == '\0' )
        {
            switch ( *ident )
            {
                case 'A':
                    return 7;

                case 'H':
                    return 4;

                case 'B':
                    return 0;

                case 'L':
                    return 5;

                case 'C':
                    return 1;

                case 'D':
                    return 2;

                case 'E':
                    return 3;

                case 'I':
                {
                    if ( ( cpu_type & CPU_RABBIT ) )
                    {
                        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT );
                        return -1;
                    }

                    return 8;
                }

                case 'R':
                {
                    if ( ( cpu_type & CPU_RABBIT ) )
                    {
                        ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT );
                        return -1;
                    }

                    return 9;
                }

                case 'F':
                    return 6;
            }
        }
        else
        {
            if ( strcmp( ident, "IXL" ) == 0 )
            {
                if ( swapIXIY == ON )
                {
                    return ( 16 + 5 );
                }
                else
                {
                    return ( 8 + 5 );
                }
            }

            else if ( strcmp( ident, "IXH" ) == 0 )
            {
                if ( swapIXIY == ON )
                {
                    return ( 16 + 4 );
                }
                else
                {
                    return ( 8 + 4 );
                }
            }

            else if ( strcmp( ident, "IYL" ) == 0 )
            {
                if ( swapIXIY == ON )
                {
                    return ( 8 + 5 );
                }
                else
                {
                    return ( 16 + 5 );
                }
            }

            else if ( strcmp( ident, "IYH" ) == 0 )
            {
                if ( swapIXIY == ON )
                {
                    return ( 8 + 4 );
                }
                else
                {
                    return ( 16 + 4 );
                }
            }

            else if ( strcmp( ident, "IIR" ) == 0 ) /** Was 'I' register */
            {
                if ( ( cpu_type & CPU_RABBIT ) )
                {
                    return 8;
                }
            }
            else if ( strcmp( ident, "EIR" ) == 0 ) /** Was 'R' register */
            {
                if ( ( cpu_type & CPU_RABBIT ) )
                {
                    return 9;
                }
            }

        }
    }

    return -1;
}


int
CheckRegister16( void )
{
    if ( sym == name )
    {
        if ( strcmp( ident, "HL" ) == 0 )
        {
            return REG16_HL;
        }
        else if ( strcmp( ident, "BC" ) == 0 )
        {
            return REG16_BC;
        }
        else if ( strcmp( ident, "DE" ) == 0 )
        {
            return REG16_DE;
        }
        else if ( strcmp( ident, "SP" ) == 0 )
        {
            return REG16_SP;
        }
        else if ( strcmp( ident, "AF" ) == 0 )
        {
            return REG16_AF;
        }
        else if ( strcmp( ident, "IX" ) == 0 )
        {
            return swapIXIY == ON ? REG16_IY : REG16_IX;
        }
        else if ( strcmp( ident, "IY" ) == 0 )
        {
            return swapIXIY == ON ? REG16_IX : REG16_IY;
        }
    }

    return -1;
}


/*
 * This function will parse the current line for an indirect addressing mode. The return code can be:
 *
 * 0 - 2   :   (BC); (DE); (HL) 5,6     :   (IX <+|- expr.> ); (IY <+|- expr.> ) 7       :   (nn), nn = 16bit address
 * expression
 *
 * The function also returns a pointer to the parsed expression, now converted to postfix.
 */
int
IndirectRegisters( void )
{
    int reg16;

    GetSym();
    reg16 = CheckRegister16();

    switch ( reg16 )
    {
        case REG16_BC:
        case REG16_DE:
        case REG16_HL:
            if ( GetSym() == rparen )
            {
                /* (BC) | (DE) | (HL) | ? */
                GetSym();
                return ( reg16 );     /* indicate (BC), (DE), (HL) */
            }
            else
            {
                ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX );     /* Right bracket missing! */
                return -1;
            }

        case REG16_IX:
        case REG16_IY:
            GetSym();                 /* prepare expression evaluation */
            return ( reg16 );

        case -1:                    /* sym could be a '+', '-' or a symbol... */
            return 7;

        default:
            ReportError( CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT );
            return -1;
    }
}


long
GetConstant( char *evalerr )
{
    long size, len, intresult = 0;
    unsigned short bitvalue = 1;

    *evalerr = 0;                 /* preset to no errors */

    if ( ( sym != hexconst ) && ( sym != binconst ) && ( sym != decmconst ) )
    {
        *evalerr = 1;
        return ( 0 );             /* syntax error - illegal constant definition */
    }

    size = strlen( ident );

    if ( sym != decmconst )
        if ( ( --size ) == 0 )
        {
            *evalerr = 1;
            return ( 0 );           /* syntax error - no constant specified */
        }

    switch ( ident[0] )
    {
        case '@':
        case '%':
            if ( size > 8 )
            {
                *evalerr = 1;
                return ( 0 );         /* max 8 bit */
            }

            for ( len = 1; len <= size; len++ )
                if ( strchr( "01", ident[len] ) == NULL )
                {
                    *evalerr = 1;
                    return ( 0 );
                }

            /* convert ASCII binary to integer */
            for ( len = size; len >= 1; len-- )
            {
                if ( ident[len] == '1' )
                {
                    intresult += bitvalue;
                }

                bitvalue <<= 1;       /* logical shift left & 16 bit 'adder' */
            }

            return ( intresult );

        case '$':
            for ( len = 1; len <= size; len++ )
                if ( isxdigit( ident[len] ) == 0 )
                {
                    *evalerr = 1;
                    return ( 0 );
                }

            sscanf( ( char * )( ident + 1 ), "%lx", &intresult );
            return ( intresult );

        default:
            for ( len = 0; len <= ( size - 1 ); len++ )
                if ( isdigit( ident[len] ) == 0 )
                {
                    *evalerr = 1;
                    return ( 0 );
                }

            return ( atol( ident ) );
    }
}

/*
 * Local Variables:
 *  indent-tabs-mode:nil
 *  require-final-newline:t
 *  c-basic-offset: 2
 *  eval: (c-set-offset 'case-label 0)
 *  eval: (c-set-offset 'substatement-open 2)
 *  eval: (c-set-offset 'access-label 0)
 *  eval: (c-set-offset 'class-open 2)
 *  eval: (c-set-offset 'class-close 2)
 * End:
 */

