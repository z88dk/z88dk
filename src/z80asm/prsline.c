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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsline.c,v 1.51 2014-03-11 23:34:00 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
#include "errors.h"
#include "init.h"
#include "list.h"
#include "listfile.h"
#include "options.h"
#include "scan.h"
#include "strutil.h"
#include "symbol.h"
#include "types.h"
#include "z80asm.h"
#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* local functions */
long GetConstant( char *evalerr );
int IndirectRegisters( void );
int CheckRegister16( void );
int CheckRegister8( void );
int CheckCondition( void );
tokid_t GetSym( void );
void Skipline( FILE *fp );
int CheckBaseType( int chcount );

/* global variables */
extern FILE *z80asmfile;
extern char ident[];
extern tokid_t sym;
extern int currentline;
extern struct module *CURRENTMODULE;

/* current input buffer */
static Str  *input_buffer = NULL;
static char *input_ptr    = "";

/* stack of previous contexts */
static List *input_stack;

static Str	*sym_string_str = NULL;
char		*sym_string     = "";	/* contains double-quoted string without quotes
									   to return with a TK_STRING */
long		 sym_number;			/* contains number to return with a TK_NUMBER */

BOOL		 EOL;

/*-----------------------------------------------------------------------------
*   Init functions
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	input_buffer = OBJ_NEW(Str);
	input_ptr    = input_buffer->str;

	input_stack	 = OBJ_NEW(List);
	input_stack->free_data = xfreef;

	sym_string_str = OBJ_NEW(Str);
	sym_string	 = sym_string_str->str;
}

DEFINE_fini()
{
	OBJ_DELETE(input_buffer);
	OBJ_DELETE(input_stack);
	OBJ_DELETE(sym_string_str);
}

/*-----------------------------------------------------------------------------
*   
*----------------------------------------------------------------------------*/

/* set new input buffer */
static void set_input_buffer( char *line )
{
	Str_set( input_buffer, line );
	input_ptr = input_buffer->str;			/* point to start, to '\0' on eof */
}

/* listfile handling */
static void getasmline( void )
{
	++CURRENTFILE->line;

    if ( !opts.line_mode )
    {
        set_error_line( CURRENTFILE->line );    /* error location */
    }

    if ( opts.cur_list )
    {
		line[0] = '\0';							/* prepare for strncat */
		strncat( line, input_buffer->str, 255 );

		list_start_line( get_PC(), CURRENTFILE->fname, CURRENTFILE->line, line );
    }
}

/* read new line from input */
static BOOL ReadLine( FILE *fp )
{
	BOOL ret;

	ret = Str_getline( input_buffer, fp );	/* read next line */
	input_ptr = input_buffer->str;			/* point to start, to '\0' on eof */

	getasmline();

	return ret;
}

/* set a new input text */
void SetTemporaryLine( char *line )
{
	init();

	List_push( & input_stack, xstrdup(input_ptr) );		/* save current input */
	set_input_buffer( line );
}

/* Unget the given char */
static void UnGet( int c )
{
	assert( input_buffer != NULL );
	assert( input_ptr > input_buffer->str && input_ptr <= input_buffer->str + input_buffer->len );

	input_ptr--;
	*input_ptr = c;
}

/* save scan position and retrieve it, for back-tracking */
char *ScanGetPos( void )
{
	init();

	return input_ptr;
}

void ScanSetPos( char *pos )
{
	init();

	assert( pos != NULL );
	assert( pos >= input_buffer->str && pos <= input_buffer->str + input_buffer->len );

	input_ptr = pos;
}

/* get a character from file */
static int GetChar( FILE *fp )
{
    int c;
	char *line;

	init();

	while (TRUE)
	{
		/* get character from current buffer */
		c = *input_ptr;
		if ( c != '\0' )
		{
			input_ptr++;
			return c;
		}

		/* get last buffer from stack, if any */
		line = List_pop( input_stack );
		if ( line != NULL )
		{
			set_input_buffer( line );
			xfree( line );
		}
		else 
		{
			/* get next line from input file */
			if ( ! ReadLine( fp ) )
				return EOF;
		}
	}
}


/* check for multi-char tokens */
static BOOL GetComposed( char *expect )
{
	size_t len = strlen(expect);

	if ( strncmp( input_ptr, expect, len ) == 0 )
	{
		input_ptr += len;
		return TRUE;
	}
	else 
		return FALSE;
}

/* get the next token */
tokid_t GetSym( void )
{
    int c, chcount = 0;

	init();

    ident[0] = '\0';

    if ( EOL )
        return (sym = TK_NEWLINE);			/* assign and return */

    for ( ;; )
    {
        /* Ignore leading white spaces, if any... */
        c = GetChar( z80asmfile );
		if ( c == EOF )
		{
	        return (sym = TK_EOF);			/* assign and return */
		}
		else if ( c == '\n' )
        {
            EOL = TRUE;
	        return (sym = TK_NEWLINE);		/* assign and return */
        }
        else if ( !isspace( c ) )
        {
            break;
        }
    }

	/* comment */
    if ( c == ';' )
    {
        Skipline( z80asmfile );				/* ignore comment line, prepare for next line */
        return (sym = TK_NEWLINE);			/* assign and return */
    }

	/* double-quoted string */
	if ( c == '"' )
	{
		char *quote = strchr( input_ptr, '"' );
		if ( quote == NULL )
		{
			error_unclosed_string();
			quote = input_ptr + strlen(input_ptr);	/* consider string up to end of input */
			if (quote > input_ptr && quote[-1] == '\n')
				quote--;							/* exclude newline */
		}

		/* copy chars up to close quote */
		Str_set( sym_string_str, input_ptr );
		sym_string_str->str[ quote - input_ptr ] = '\0';
		Str_sync_len( sym_string_str );

		sym_string = sym_string_str->str;

		input_ptr = quote;					/* advance past string */
		if ( *input_ptr == '"' )
			input_ptr++;					/* advance past quote */

		return (sym = TK_STRING);			/* assign and return */
	}

	/* single-quoted string */
	if ( c == '\'' )
	{
		char *quote = strchr( input_ptr, '\'' );
		if ( quote == NULL || quote - input_ptr != 1 )	/* only 1-char quoted strings */
		{
			sym_number = 0;
			error_invalid_squoted_string();
			Skipline( z80asmfile );
		}
		else
		{
			sym_number = (byte_t) input_ptr[0];
			input_ptr = quote + 1;			/* advance past string */
		}

		return (sym = TK_NUMBER);			/* assign and return */
	}

	/* special cases for composed separators */
	if ( ispunct(c) )
	{
		input_ptr--;

		if ( GetComposed( "**" ) ) return (sym = TK_POWER);			/* assign and return */
		if ( GetComposed( "==" ) ) return (sym = TK_EQUAL);			/* assign and return */
		if ( GetComposed( "!=" ) ) return (sym = TK_NOT_EQ);		/* assign and return */
		if ( GetComposed( "<>" ) ) return (sym = TK_NOT_EQ);		/* assign and return */
		if ( GetComposed( "<=" ) ) return (sym = TK_LESS_EQ);		/* assign and return */
		if ( GetComposed( ">=" ) ) return (sym = TK_GREATER_EQ);	/* assign and return */
		if ( GetComposed( "<<" ) ) return (sym = TK_LEFT_SHIFT);	/* assign and return */
		if ( GetComposed( ">>" ) ) return (sym = TK_RIGHT_SHIFT);	/* assign and return */
		if ( GetComposed( "&&" ) ) return (sym = TK_LOG_AND);		/* assign and return */
		if ( GetComposed( "||" ) ) return (sym = TK_LOG_OR);		/* assign and return */

		input_ptr++;
	}

	/* single char separators */
	sym = char_token( c );
	if ( sym != TK_NIL )
		return sym;

    ident[chcount++] = ( char ) toupper( c );

    switch ( c )
    {
    case '$':
        sym = TK_HEX_CONST;
        break;

    case '@':
    case '%':       /* not reached, as '%' is a separator */
        sym = TK_BIN_CONST;
        break;

    case '#':       /* not reached, as '#' is a separator */
        sym = TK_NAME;
        break;

    default:
        if ( isdigit( c ) )
        {
            sym = TK_DEC_CONST;      /* a decimal number found */
        }
        else
        {
            if ( isalpha( c ) || c == '_' )
            {
                sym = TK_NAME;       /* an identifier found */
            }
            else
            {
                sym = TK_NIL;        /* rubbish ... */
            }
        }

        break;
    }

    /* Read identifier until space or legal separator is found */
    if ( sym == TK_NAME )
    {
        while (1)
        {
            c = GetChar( z80asmfile );
			if ( c == EOF )
				break;

			if ( !isalnum( c ) && c != '_' )
			{
				if ( c == ':' )					/* eat ':' if any */
					sym = TK_LABEL;
				else
					UnGet( c );
				break;
			}

			ident[chcount++] = toupper( c );
		}
    }
    else
    {
        while (1)
        {
            c = GetChar( z80asmfile );
			if ( c == EOF )
				break;

			if ( !isalnum( c ) )
			{
				UnGet( c );
				break;
			}
			ident[chcount++] = c;
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

	init();

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
            sym = TK_HEX_CONST;
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
            sym = TK_HEX_CONST;
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
        sym = TK_BIN_CONST;
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
        sym = TK_DEC_CONST;
        return chcount - 1;
    }

    return chcount;
}





void
Skipline( FILE *fp )
{
	init();

	if ( ! EOL )
	{
		while ( *input_ptr != '\0' && *input_ptr != '\n' )
			input_ptr++;

		if ( *input_ptr == '\n' )
			input_ptr++;
		
		EOL = TRUE;
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
    uint_t  i;
    char   *text = ident;
    uint_t  len = strlen( text );

	init();

    for ( i = 0; i < NUM_ELEMS( flags ); i++ )
    {
        if ( len != strlen( flags[i].name ) )
        {
            continue;
        }

        if ( strcmp( text, flags[i].name ) == 0 )
        {
            if ( ( opts.cpu & flags[i].cpu ) == 0 )
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
	init();

    if ( sym == TK_NAME )
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
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    error_illegal_ident();
                    return -1;
                }

                return 8;
            }

            case 'R':
            {
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    error_illegal_ident();
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
                if ( opts.swap_ix_iy )
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
                if ( opts.swap_ix_iy )
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
                if ( opts.swap_ix_iy )
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
                if ( opts.swap_ix_iy )
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
                if ( ( opts.cpu & CPU_RABBIT ) )
                {
                    return 8;
                }
            }
            else if ( strcmp( ident, "EIR" ) == 0 ) /** Was 'R' register */
            {
                if ( ( opts.cpu & CPU_RABBIT ) )
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
	init();

    if ( sym == TK_NAME )
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
            return opts.swap_ix_iy ? REG16_IY : REG16_IX;
        }
        else if ( strcmp( ident, "IY" ) == 0 )
        {
            return opts.swap_ix_iy ? REG16_IX : REG16_IY;
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

	init();

    GetSym();
    reg16 = CheckRegister16();

    switch ( reg16 )
    {
    case REG16_BC:
    case REG16_DE:
    case REG16_HL:
        if ( GetSym() == TK_RPAREN )
        {
            /* (BC) | (DE) | (HL) | ? */
            GetSym();
            return ( reg16 );     /* indicate (BC), (DE), (HL) */
        }
        else
        {
            error_syntax();     /* Right bracket missing! */
            return -1;
        }

    case REG16_IX:
    case REG16_IY:
        GetSym();                 /* prepare expression evaluation */
        return ( reg16 );

    case -1:                    /* sym could be a '+', '-' or a symbol... */
        return 7;

    default:
        error_illegal_ident();
        return -1;
    }
}


long
GetConstant( char *evalerr )
{
    long size, len, intresult = 0;
    uint_t bitvalue = 1;

	init();

    *evalerr = 0;                 /* preset to no errors */

    if ( ( sym != TK_HEX_CONST ) && ( sym != TK_BIN_CONST ) && ( sym != TK_DEC_CONST ) )
    {
        *evalerr = 1;
        return ( 0 );             /* syntax error - illegal constant definition */
    }

    size = strlen( ident );

    if ( sym != TK_DEC_CONST )
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
* $Log: prsline.c,v $
* Revision 1.51  2014-03-11 23:34:00  pauloscustodio
* Remove check for feof(z80asmfile), add token TK_EOF to return on EOF.
* Allows decoupling of input file used in scanner from callers.
* Removed TOTALLINES.
* GetChar() made static to scanner, not called by other modules.
*
* Revision 1.50  2014/03/11 22:59:20  pauloscustodio
* Move EOL flag to scanner
*
* Revision 1.49  2014/03/11 00:15:13  pauloscustodio
* Scanner reads input line-by-line instead of character-by-character.
* Factor house-keeping at each new line read in the scanner getasmline().
* Add interface to allow back-tacking of the recursive descent parser by
* getting the current input buffer position and comming back to the same later.
* SetTemporaryLine() keeps a stack of previous input lines.
* Scanner handles single-quoted strings and returns a number.
* New error for single-quoted string with length != 1.
* Scanner handles double-quoted strings and returns the quoted string.
*
* Revision 1.48  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.47  2014/03/02 12:51:41  pauloscustodio
* Change token ids to TK_...
*
* Revision 1.46  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.45  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.44  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.43  2014/02/23 18:48:16  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, ?:
* Handle C-like operators ==, !=, &&, || and ?:.
* Simplify expression parser by handling composed tokens in lexer.
*
* Revision 1.42  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.41  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.40  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.39  2013/12/15 19:01:07  pauloscustodio
* Move platform specific defines from types.h to config.h.
* Remove dependency of types.h from glib.h.
* Use NUM_ELEMS() instead of glib G_N_ELEMENTS().
*
* Revision 1.38  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.37  2013/10/04 23:31:50  pauloscustodio
* Parse command line options via look-up tables:
* -IXIY, --swap-ix-iy
*
* Revision 1.36  2013/10/04 23:09:25  pauloscustodio
* Parse command line options via look-up tables:
* -R, --relocatable
* --RCMX000
*
* Revision 1.35  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.34  2013/09/01 18:45:35  pauloscustodio
* Remove NUM_ELEMS, use G_N_ELEMENTS instead (from glib.h)
* Remove FALSE, TRUE, MIN, MAX; defined in glib.h
*
* Revision 1.33  2013/08/29 22:01:20  pauloscustodio
* Accept ** as power  operator
*
* Revision 1.32  2013/05/12 19:39:32  pauloscustodio
* warnings
*
* Revision 1.31  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (byte_t)
* Replaced (unisigned int) by (uint_t)
* Replaced (short) by (int)
*
* Revision 1.30  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.29  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
*
* Revision 1.28  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.27  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.26  2012/05/20 06:39:27  pauloscustodio
* astyle
*
* Revision 1.25  2012/05/20 06:37:31  pauloscustodio
* Comments on unreachable cases in GetSym()
*
* Revision 1.24  2012/05/20 05:31:18  pauloscustodio
* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
*
* Revision 1.23  2012/05/12 16:54:49  pauloscustodio
* temporary_start not used, removed
*
* Revision 1.22  2012/05/11 19:29:49  pauloscustodio
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
* Revision 1.21  2011/08/05 19:59:51  pauloscustodio
* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
*
* Revision 1.20  2011/07/18 00:48:25  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*
* Revision 1.19  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
* Revision 1.18  2011/07/11 16:07:16  pauloscustodio
* Moved all option variables and option handling code to a separate module options.c,
* replaced all extern declarations of these variables by include options.h.
*
* Revision 1.17  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
*
* Revision 1.16  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
*
* Revision 1.15  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
*
* Revision 1.14  2011/07/09 01:23:13  pauloscustodio
* BUG_0001 : Error in expression during link, expression garbled - memory corruption?
*      Simple asm program: "org 0 \n jp NN \n jp NN \n NN: \n",
*      compile with "z80asm -t4 -b test.asm"
*      fails with: "File 'test.asm', Module 'TEST', Syntax error in expression \n
*                   Error in expression +¶+≤+-;æ?.π“¶“≤Ÿ+v›F›V›^›x¶ ›@›H›P›".
*      Problem cause: lexer GetSym() is not prepared to read '\0' bytes.
*      When the expression is read from the OBJ file at the link phase, the '\0'
*      at the end of the expression field is interpreted as a random separator
*      because ssym[] contains fewer elements (27) than the separators string (28);
*      hence in some cases the expression is parsed correctly, e.g. without -t4
*      the program assembles correctly.
*      If the random separator is a semicolon, GetSym() calls Skipline() to go past
*      the comment, and reads past the end of the expression in the OBJ file,
*      causing the parse of the next expression to fail.
*
* Revision 1.13  2010/04/16 17:34:37  dom
* Make line number an int - 32768 lines isn't big enough...
*
* Revision 1.12  2009/08/14 22:23:12  dom
* clean up some compiler warnings
*
* Revision 1.11  2009/07/18 23:23:15  dom
* clean up the code a bit more (Formatting and a fewer magic numbers)
*
* Revision 1.10  2007/06/17 12:07:43  dom
* Commit the rabbit emulation code including rrd, rld
*
* Add a .vcproj for visual studio
*
* Revision 1.9  2007/02/28 11:23:24  stefano
* New platform !
* Rabbit Control Module 2000/3000.
*
* Revision 1.8  2002/04/22 14:45:51  stefano
* Removed the SLL L undocumented instructions from the Graph library.
* NEW startup=2 mode for the ZX81 (SLOW mode... hoping we'll make it work in the future).
* MS Visual C compiler related fixes
* -IXIY option on Z80ASM to swap the IX and IY registers
*
* Revision 1.7  2002/01/18 21:12:17  dom
* 0x prefix allowed for hex constants
*
* Revision 1.6  2002/01/18 16:55:40  dom
* minor bug fix on the previous commit
*
* Revision 1.5  2002/01/18 16:53:13  dom
* added 'd' and 'b' identifiers for constants - decimal and binary
* respectively.
*
* Revision 1.4  2002/01/16 21:56:43  dom
* we now accept h as a post modifier for hex numbers eg:
*      ld      a,20h == ld a,$20 == ld a,32
*
* Revision 1.3  2001/04/11 09:48:18  dom
* Minor fix to allow labels to end in ':'
*
* Revision 1.2  2001/03/21 16:34:01  dom
* Added changes to allow labels to end in ':' and the prefix '.' isn't
* necessarily needed..this isn't guaranteed to be perfect so let me know
* of any problems and drop back to 1.0.18
*
* Revision 1.1  2000/07/04 15:33:30  dom
* branches:  1.1.1;
* Initial revision
*
* Revision 1.1.1.1  2000/07/04 15:33:30  dom
* First import of z88dk into the sourceforge system <gulp>
*
*/

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
