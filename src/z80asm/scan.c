
//#line 1 "scan.rl"
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

Copyright (C) Paulo Custodio, 2011-2014

Scanner - to be processed by: ragel -G2 scan.rl
Note: the scanner is not reentrant. scan_get() relies on state variables that
need to be kept across calls.

:Header: /cvsroot/z88dk/z88dk/src/z80asm/scan.rl,v 1.13 2014/02/19 23:59:26 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "scan.h"

#include "errors.h"
#include "types.h"

#include <assert.h>
#include <ctype.h>

static long  scan_num( char *text, int num_suffix_chars, int base );
static char *copy_token_str( char *text, uint_t len );

/*-----------------------------------------------------------------------------
* 	Globals that keep last token read
*----------------------------------------------------------------------------*/
DEFINE_STR(	scan_buffer, MAXLINE );		/* keep a copy of string being scanned */
DEFINE_STR(	token_str, MAXLINE );		/* keep a copy of last token string */

Token	 last_token;
long	 last_token_num;
char	*last_token_str = "";

/*-----------------------------------------------------------------------------
* 	Static - current scan context
*----------------------------------------------------------------------------*/
static BOOL	 at_bol;				/* true if at beginning of line */

/* Ragel state variables */
static int	 cs, act;			
static char	*p, *pe, *eof, *ts, *te;

/*-----------------------------------------------------------------------------
* Z80ASM scanner
*----------------------------------------------------------------------------*/

//#line 202 "scan.rl"



//#line 65 "scan.c"
static const int asm_start = 7;
static const int asm_error = 0;

static const int asm_en_main = 7;


//#line 205 "scan.rl"

/*-----------------------------------------------------------------------------
*	convert number to int, range warning if greater than INT_MAX
*----------------------------------------------------------------------------*/
static long scan_num ( char *text, int length, int base )
{
	long value;
	int digit = 0;
	char c;
	int i;
	BOOL range_err;
	
	value = 0;
	range_err = FALSE;
	for ( i = 0 ; i < length ; i++ ) 
	{
		c = *text++;					/* read each digit */
		if ( isdigit(c) ) 
		{
			digit = c - '0';
		}
		else if ( isalpha(c) ) 
		{
			digit = toupper(c) - 'A' + 10;
		}
		else if ( base == 2 && (c == '-' || c == '#') ) 
		{
			digit = (c == '#') ? 1 : 0;
		}
		else 
		{
			assert(0); /* invalid digit - should not be reached */
		}

		if (digit >= base) 
		{
			assert(0); /* digit out of range - should not be reached */
		}
		
		value = value * base + digit;

		if ( ! range_err && value < 0 )	/* overflow to sign bit */
		{
			range_err = TRUE;		
		}
	}
	
	if ( range_err )
	{
		warn_int_range( value );
	}
		
	return value;
}

/*-----------------------------------------------------------------------------
*	copy characters into token string buffer, set last_token_str
*----------------------------------------------------------------------------*/
static char *copy_token_str( char *text, uint_t len )
{
	/* copy to buffer */
	Str_set( token_str, text );								/* copy all chars */
	token_str->str[ MIN( len, token_str->len ) ] = '\0';	/* truncate */
	Str_sync_len( token_str );
	
	return token_str->str;
}

/*-----------------------------------------------------------------------------
*	Scan API
*----------------------------------------------------------------------------*/

void scan_reset( char *text, BOOL _at_bol )
{
	Str_set( scan_buffer, text );
	
	/* init state */
	at_bol  = _at_bol;
	p		= scan_buffer->str;
	pe		= scan_buffer->str + scan_buffer->len;
	eof		= pe;	/* tokens are not split acros input lines */
	
	
//#line 156 "scan.c"
	{
	cs = asm_start;
	ts = 0;
	te = 0;
	act = 0;
	}

//#line 288 "scan.rl"

	last_token = T_END;
}

Token scan_get( void )
{
	last_token = T_END;

	
//#line 174 "scan.c"
	{
	short _widec;
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
//#line 90 "scan.rl"
	{{p = ((te))-1;}{ last_token = ts[0];		{p++; cs = 7; goto _out;} }}
	goto st7;
tr2:
//#line 146 "scan.rl"
	{te = p+1;{ 
		last_token_num = scan_num( ts + 2, te - ts - 3, 2 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr3:
//#line 1 "NONE"
	{	switch( act ) {
	case 4:
	{{p = ((te))-1;} last_token = ts[0];		{p++; cs = 7; goto _out;} }
	break;
	case 15:
	{{p = ((te))-1;} 
		last_token_num = scan_num( ts, te - ts, 10 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}
	break;
	case 17:
	{{p = ((te))-1;} 
		last_token_num = scan_num( ts + 1, te - ts - 1, 16 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}
	break;
	case 19:
	{{p = ((te))-1;} 
		last_token_num = scan_num( ts, te - ts - 1, 2 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}
	break;
	case 21:
	{{p = ((te))-1;} 
		last_token_num = scan_num( ts + 2, te - ts - 2, 2 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}
	break;
	case 23:
	{{p = ((te))-1;} last_token = T_ADD;		{p++; cs = 7; goto _out;} }
	break;
	case 24:
	{{p = ((te))-1;} last_token = T_LD;		{p++; cs = 7; goto _out;} }
	break;
	case 25:
	{{p = ((te))-1;} last_token = T_NOP;		{p++; cs = 7; goto _out;} }
	break;
	case 26:
	{{p = ((te))-1;}
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_NAME;
		{p++; cs = 7; goto _out;}
	}
	break;
	case 27:
	{{p = ((te))-1;}
		/* remove '.' and ':' */
		while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
		while ( te[-1] == ':' || isspace(te[-1]) ) te--;
		
		/* copy token */
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_LABEL;
		{p++; cs = 7; goto _out;}
	}
	break;
	}
	}
	goto st7;
tr5:
//#line 110 "scan.rl"
	{te = p+1;{ 
		last_token_num = scan_num( ts, te - ts - 1, 16 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr6:
//#line 104 "scan.rl"
	{{p = ((te))-1;}{ 
		last_token_num = scan_num( ts, te - ts, 10 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr11:
//#line 167 "scan.rl"
	{te = p+1;{
		/* remove '.' and ':' */
		while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
		while ( te[-1] == ':' || isspace(te[-1]) ) te--;
		
		/* copy token */
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_LABEL;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr12:
//#line 87 "scan.rl"
	{te = p+1;}
	goto st7;
tr13:
//#line 81 "scan.rl"
	{te = p+1;{ last_token = T_NEWLINE; {p++; cs = 7; goto _out;} }}
	goto st7;
tr20:
//#line 90 "scan.rl"
	{te = p+1;{ last_token = ts[0];		{p++; cs = 7; goto _out;} }}
	goto st7;
tr39:
//#line 90 "scan.rl"
	{te = p;p--;{ last_token = ts[0];		{p++; cs = 7; goto _out;} }}
	goto st7;
tr40:
//#line 93 "scan.rl"
	{te = p+1;{ last_token = T_EXCLAM_EQ; {p++; cs = 7; goto _out;} }}
	goto st7;
tr41:
//#line 199 "scan.rl"
	{te = p;p--;{ error_unclosed_string(); }}
	goto st7;
tr42:
//#line 194 "scan.rl"
	{te = p+1;{
		last_token_str = copy_token_str( ts+1, te-ts-2 );
		last_token = T_STRING;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr46:
//#line 134 "scan.rl"
	{te = p;p--;{ 
		last_token_num = scan_num( ts + 1, te - ts - 1, 2 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr47:
//#line 97 "scan.rl"
	{te = p+1;{ last_token = T_AND_AND; 	{p++; cs = 7; goto _out;} }}
	goto st7;
tr48:
//#line 190 "scan.rl"
	{te = p;p--;{ error_invalid_squoted_string(); }}
	goto st7;
tr49:
//#line 180 "scan.rl"
	{te = p+1;{
		if ( te - ts == 3 )
		{
			last_token_num = ts[1];
			last_token = T_NUMBER;
			{p++; cs = 7; goto _out;}
		}
		else
			error_invalid_squoted_string();
	}}
	goto st7;
tr50:
//#line 100 "scan.rl"
	{te = p+1;{ last_token = T_STAR_STAR; {p++; cs = 7; goto _out;} }}
	goto st7;
tr51:
//#line 104 "scan.rl"
	{te = p;p--;{ 
		last_token_num = scan_num( ts, te - ts, 10 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr56:
//#line 128 "scan.rl"
	{te = p;p--;{ 
		last_token_num = scan_num( ts, te - ts - 1, 2 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr58:
//#line 122 "scan.rl"
	{te = p;p--;{ 
		last_token_num = scan_num( ts + 2, te - ts - 2, 16 ); 
		last_token = T_NUMBER;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr59:
//#line 84 "scan.rl"
	{te = p;p--;}
	goto st7;
tr60:
//#line 98 "scan.rl"
	{te = p+1;{ last_token = T_LT_LT; 	{p++; cs = 7; goto _out;} }}
	goto st7;
tr61:
//#line 94 "scan.rl"
	{te = p+1;{ last_token = T_LT_EQ; 	{p++; cs = 7; goto _out;} }}
	goto st7;
tr62:
//#line 92 "scan.rl"
	{te = p+1;{ last_token = T_LT_GT; 	{p++; cs = 7; goto _out;} }}
	goto st7;
tr63:
//#line 91 "scan.rl"
	{te = p+1;{ last_token = T_EQ_EQ; 	{p++; cs = 7; goto _out;} }}
	goto st7;
tr64:
//#line 95 "scan.rl"
	{te = p+1;{ last_token = T_GT_EQ; 	{p++; cs = 7; goto _out;} }}
	goto st7;
tr65:
//#line 99 "scan.rl"
	{te = p+1;{ last_token = T_GT_GT; 	{p++; cs = 7; goto _out;} }}
	goto st7;
tr66:
//#line 96 "scan.rl"
	{te = p+1;{ last_token = T_VBAR_VBAR; {p++; cs = 7; goto _out;} }}
	goto st7;
tr67:
//#line 159 "scan.rl"
	{te = p;p--;{
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_NAME;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr71:
//#line 159 "scan.rl"
	{te = p+1;{
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_NAME;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
tr75:
//#line 167 "scan.rl"
	{te = p;p--;{
		/* remove '.' and ':' */
		while ( ts[ 0] == '.' || isspace(ts[ 0]) ) ts++;
		while ( te[-1] == ':' || isspace(te[-1]) ) te--;
		
		/* copy token */
		last_token_str = strtoupper( copy_token_str( ts, te-ts ) );
		last_token = T_LABEL;
		{p++; cs = 7; goto _out;}
	}}
	goto st7;
st7:
//#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof7;
case 7:
//#line 1 "NONE"
	{ts = p;}
//#line 445 "scan.c"
	_widec = (*p);
	if ( (*p) < 65 ) {
		if ( 46 <= (*p) && (*p) <= 46 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 90 ) {
		if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 95 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 10: goto tr13;
		case 33: goto st8;
		case 34: goto st9;
		case 37: goto tr17;
		case 38: goto st13;
		case 39: goto st14;
		case 42: goto st15;
		case 47: goto tr20;
		case 48: goto tr23;
		case 59: goto st22;
		case 60: goto st23;
		case 61: goto st24;
		case 62: goto st25;
		case 64: goto tr17;
		case 96: goto tr20;
		case 124: goto st26;
		case 127: goto tr12;
		case 302: goto tr20;
		case 321: goto st27;
		case 332: goto st31;
		case 334: goto st32;
		case 351: goto tr31;
		case 353: goto st27;
		case 364: goto st31;
		case 366: goto st32;
		case 558: goto tr34;
		case 577: goto tr35;
		case 588: goto tr37;
		case 590: goto tr38;
		case 607: goto tr36;
		case 609: goto tr35;
		case 620: goto tr37;
		case 622: goto tr38;
	}
	if ( _widec < 91 ) {
		if ( _widec < 40 ) {
			if ( _widec > 32 ) {
				if ( 35 <= _widec && _widec <= 36 )
					goto tr16;
			} else
				goto tr12;
		} else if ( _widec > 45 ) {
			if ( _widec > 57 ) {
				if ( 58 <= _widec && _widec <= 63 )
					goto tr20;
			} else if ( _widec >= 49 )
				goto tr24;
		} else
			goto tr20;
	} else if ( _widec > 94 ) {
		if ( _widec < 354 ) {
			if ( _widec > 126 ) {
				if ( 322 <= _widec && _widec <= 346 )
					goto tr31;
			} else if ( _widec >= 123 )
				goto tr20;
		} else if ( _widec > 378 ) {
			if ( _widec > 602 ) {
				if ( 610 <= _widec && _widec <= 634 )
					goto tr36;
			} else if ( _widec >= 578 )
				goto tr36;
		} else
			goto tr31;
	} else
		goto tr20;
	goto st0;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
	if ( (*p) == 61 )
		goto tr40;
	goto tr39;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
	switch( (*p) ) {
		case 10: goto tr41;
		case 34: goto tr42;
	}
	goto st9;
tr16:
//#line 1 "NONE"
	{te = p+1;}
//#line 90 "scan.rl"
	{act = 4;}
	goto st10;
tr43:
//#line 1 "NONE"
	{te = p+1;}
//#line 116 "scan.rl"
	{act = 17;}
	goto st10;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
//#line 574 "scan.c"
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr43;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto tr43;
	} else
		goto tr43;
	goto tr3;
tr17:
//#line 1 "NONE"
	{te = p+1;}
	goto st11;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
//#line 592 "scan.c"
	if ( (*p) == 34 )
		goto st1;
	if ( 48 <= (*p) && (*p) <= 49 )
		goto st12;
	goto tr39;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	switch( (*p) ) {
		case 35: goto st2;
		case 45: goto st2;
	}
	goto tr0;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	switch( (*p) ) {
		case 34: goto tr2;
		case 35: goto st2;
		case 45: goto st2;
	}
	goto tr0;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
	if ( 48 <= (*p) && (*p) <= 49 )
		goto st12;
	goto tr46;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	if ( (*p) == 38 )
		goto tr47;
	goto tr39;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
	switch( (*p) ) {
		case 10: goto tr48;
		case 39: goto tr49;
	}
	goto st14;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
	if ( (*p) == 42 )
		goto tr50;
	goto tr39;
st0:
cs = 0;
	goto _out;
tr23:
//#line 1 "NONE"
	{te = p+1;}
//#line 104 "scan.rl"
	{act = 15;}
	goto st16;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
//#line 660 "scan.c"
	switch( (*p) ) {
		case 66: goto tr53;
		case 72: goto tr5;
		case 88: goto st4;
		case 98: goto tr53;
		case 104: goto tr5;
		case 120: goto st4;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr24;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st3;
		} else if ( (*p) >= 65 )
			goto st3;
	} else
		goto tr52;
	goto tr51;
tr24:
//#line 1 "NONE"
	{te = p+1;}
//#line 104 "scan.rl"
	{act = 15;}
	goto st17;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
//#line 691 "scan.c"
	switch( (*p) ) {
		case 66: goto tr55;
		case 72: goto tr5;
		case 98: goto tr55;
		case 104: goto tr5;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr24;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st3;
		} else if ( (*p) >= 65 )
			goto st3;
	} else
		goto tr52;
	goto tr51;
tr52:
//#line 1 "NONE"
	{te = p+1;}
//#line 104 "scan.rl"
	{act = 15;}
	goto st18;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
//#line 720 "scan.c"
	switch( (*p) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr52;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st3;
	} else
		goto st3;
	goto tr51;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
	switch( (*p) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st3;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st3;
	} else
		goto st3;
	goto tr3;
tr55:
//#line 1 "NONE"
	{te = p+1;}
//#line 128 "scan.rl"
	{act = 19;}
	goto st19;
st19:
	if ( ++p == pe )
		goto _test_eof19;
case 19:
//#line 761 "scan.c"
	switch( (*p) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st3;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st3;
	} else
		goto st3;
	goto tr56;
tr53:
//#line 1 "NONE"
	{te = p+1;}
//#line 128 "scan.rl"
	{act = 19;}
	goto st20;
tr57:
//#line 1 "NONE"
	{te = p+1;}
//#line 140 "scan.rl"
	{act = 21;}
	goto st20;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
//#line 791 "scan.c"
	switch( (*p) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*p) < 50 ) {
		if ( 48 <= (*p) && (*p) <= 49 )
			goto tr57;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 70 ) {
			if ( 97 <= (*p) && (*p) <= 102 )
				goto st3;
		} else if ( (*p) >= 65 )
			goto st3;
	} else
		goto st3;
	goto tr3;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st21;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st21;
	} else
		goto st21;
	goto tr6;
st21:
	if ( ++p == pe )
		goto _test_eof21;
case 21:
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st21;
	} else if ( (*p) > 70 ) {
		if ( 97 <= (*p) && (*p) <= 102 )
			goto st21;
	} else
		goto st21;
	goto tr58;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
	if ( (*p) == 10 )
		goto tr59;
	goto st22;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	switch( (*p) ) {
		case 60: goto tr60;
		case 61: goto tr61;
		case 62: goto tr62;
	}
	goto tr39;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
	if ( (*p) == 61 )
		goto tr63;
	goto tr39;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
	switch( (*p) ) {
		case 61: goto tr64;
		case 62: goto tr65;
	}
	goto tr39;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
	if ( (*p) == 124 )
		goto tr66;
	goto tr39;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	switch( (*p) ) {
		case 68: goto st29;
		case 70: goto st30;
		case 95: goto tr31;
		case 100: goto st29;
		case 102: goto st30;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr31;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr31;
	} else
		goto tr31;
	goto tr67;
tr31:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st28;
tr70:
//#line 1 "NONE"
	{te = p+1;}
//#line 153 "scan.rl"
	{act = 23;}
	goto st28;
tr72:
//#line 1 "NONE"
	{te = p+1;}
//#line 154 "scan.rl"
	{act = 24;}
	goto st28;
tr74:
//#line 1 "NONE"
	{te = p+1;}
//#line 155 "scan.rl"
	{act = 25;}
	goto st28;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
//#line 922 "scan.c"
	if ( (*p) == 95 )
		goto tr31;
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr31;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr31;
	} else
		goto tr31;
	goto tr3;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	switch( (*p) ) {
		case 68: goto tr70;
		case 95: goto tr31;
		case 100: goto tr70;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr31;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr31;
	} else
		goto tr31;
	goto tr67;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	switch( (*p) ) {
		case 39: goto tr71;
		case 95: goto tr31;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr31;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr31;
	} else
		goto tr31;
	goto tr67;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
	switch( (*p) ) {
		case 68: goto tr72;
		case 95: goto tr31;
		case 100: goto tr72;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr31;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr31;
	} else
		goto tr31;
	goto tr67;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
	switch( (*p) ) {
		case 79: goto st33;
		case 95: goto tr31;
		case 111: goto st33;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr31;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr31;
	} else
		goto tr31;
	goto tr67;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	switch( (*p) ) {
		case 80: goto tr74;
		case 95: goto tr31;
		case 112: goto tr74;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto tr31;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr31;
	} else
		goto tr31;
	goto tr67;
tr34:
//#line 1 "NONE"
	{te = p+1;}
	goto st34;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
//#line 1031 "scan.c"
	_widec = (*p);
	if ( (*p) < 65 ) {
		if ( (*p) > 9 ) {
			if ( 32 <= (*p) && (*p) <= 32 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 9 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 90 ) {
		if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 95 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 521: goto st5;
		case 544: goto st5;
		case 607: goto tr9;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto tr9;
	} else if ( _widec >= 577 )
		goto tr9;
	goto tr39;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
	_widec = (*p);
	if ( (*p) < 65 ) {
		if ( (*p) > 9 ) {
			if ( 32 <= (*p) && (*p) <= 32 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 9 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 90 ) {
		if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) >= 95 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 521: goto st5;
		case 544: goto st5;
		case 607: goto tr9;
	}
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto tr9;
	} else if ( _widec >= 577 )
		goto tr9;
	goto tr0;
tr9:
//#line 1 "NONE"
	{te = p+1;}
//#line 167 "scan.rl"
	{act = 27;}
	goto st35;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
//#line 1138 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 607: goto tr9;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto tr9;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto tr9;
	} else
		goto tr9;
	goto tr75;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	_widec = (*p);
	if ( (*p) < 32 ) {
		if ( 9 <= (*p) && (*p) <= 9 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 32 ) {
		if ( 58 <= (*p) && (*p) <= 58 ) {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
	}
	goto tr3;
tr35:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st36;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
//#line 1244 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto st29;
		case 326: goto st30;
		case 351: goto tr31;
		case 356: goto st29;
		case 358: goto st30;
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 580: goto tr76;
		case 582: goto tr77;
		case 607: goto tr36;
		case 612: goto tr76;
		case 614: goto tr77;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr31;
		} else if ( _widec >= 304 )
			goto tr31;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr36;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr36;
		} else
			goto tr36;
	} else
		goto tr31;
	goto tr67;
tr36:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st37;
tr78:
//#line 1 "NONE"
	{te = p+1;}
//#line 153 "scan.rl"
	{act = 23;}
	goto st37;
tr79:
//#line 1 "NONE"
	{te = p+1;}
//#line 154 "scan.rl"
	{act = 24;}
	goto st37;
tr81:
//#line 1 "NONE"
	{te = p+1;}
//#line 155 "scan.rl"
	{act = 25;}
	goto st37;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
//#line 1355 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 351: goto tr31;
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 607: goto tr36;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr31;
		} else if ( _widec >= 304 )
			goto tr31;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr36;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr36;
		} else
			goto tr36;
	} else
		goto tr31;
	goto tr3;
tr76:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st38;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
//#line 1440 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto tr70;
		case 351: goto tr31;
		case 356: goto tr70;
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 580: goto tr78;
		case 607: goto tr36;
		case 612: goto tr78;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr31;
		} else if ( _widec >= 304 )
			goto tr31;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr36;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr36;
		} else
			goto tr36;
	} else
		goto tr31;
	goto tr67;
tr77:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st39;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
//#line 1529 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 39: goto tr71;
		case 351: goto tr31;
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 607: goto tr36;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr31;
		} else if ( _widec >= 304 )
			goto tr31;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr36;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr36;
		} else
			goto tr36;
	} else
		goto tr31;
	goto tr67;
tr37:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st40;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
//#line 1615 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 324: goto tr72;
		case 351: goto tr31;
		case 356: goto tr72;
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 580: goto tr79;
		case 607: goto tr36;
		case 612: goto tr79;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr31;
		} else if ( _widec >= 304 )
			goto tr31;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr36;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr36;
		} else
			goto tr36;
	} else
		goto tr31;
	goto tr67;
tr38:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
//#line 1704 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 335: goto st33;
		case 351: goto tr31;
		case 367: goto st33;
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 591: goto tr80;
		case 607: goto tr36;
		case 623: goto tr80;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr31;
		} else if ( _widec >= 304 )
			goto tr31;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr36;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr36;
		} else
			goto tr36;
	} else
		goto tr31;
	goto tr67;
tr80:
//#line 1 "NONE"
	{te = p+1;}
//#line 159 "scan.rl"
	{act = 26;}
	goto st42;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
//#line 1793 "scan.c"
	_widec = (*p);
	if ( (*p) < 58 ) {
		if ( (*p) < 32 ) {
			if ( 9 <= (*p) && (*p) <= 9 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 32 ) {
			if ( 48 <= (*p) && (*p) <= 57 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else if ( (*p) > 58 ) {
		if ( (*p) < 95 ) {
			if ( 65 <= (*p) && (*p) <= 90 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else if ( (*p) > 95 ) {
			if ( 97 <= (*p) && (*p) <= 122 ) {
				_widec = (short)(128 + ((*p) - -128));
				if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
			}
		} else {
			_widec = (short)(128 + ((*p) - -128));
			if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*p) - -128));
		if ( 
//#line 61 "scan.rl"
 at_bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 336: goto tr74;
		case 351: goto tr31;
		case 368: goto tr74;
		case 521: goto st6;
		case 544: goto st6;
		case 570: goto tr11;
		case 592: goto tr81;
		case 607: goto tr36;
		case 624: goto tr81;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto tr31;
		} else if ( _widec >= 304 )
			goto tr31;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto tr36;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto tr36;
		} else
			goto tr36;
	} else
		goto tr31;
	goto tr67;
	}
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof29: cs = 29; goto _test_eof; 
	_test_eof30: cs = 30; goto _test_eof; 
	_test_eof31: cs = 31; goto _test_eof; 
	_test_eof32: cs = 32; goto _test_eof; 
	_test_eof33: cs = 33; goto _test_eof; 
	_test_eof34: cs = 34; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof35: cs = 35; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof36: cs = 36; goto _test_eof; 
	_test_eof37: cs = 37; goto _test_eof; 
	_test_eof38: cs = 38; goto _test_eof; 
	_test_eof39: cs = 39; goto _test_eof; 
	_test_eof40: cs = 40; goto _test_eof; 
	_test_eof41: cs = 41; goto _test_eof; 
	_test_eof42: cs = 42; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 8: goto tr39;
	case 9: goto tr41;
	case 10: goto tr3;
	case 11: goto tr39;
	case 1: goto tr0;
	case 2: goto tr0;
	case 12: goto tr46;
	case 13: goto tr39;
	case 14: goto tr48;
	case 15: goto tr39;
	case 16: goto tr51;
	case 17: goto tr51;
	case 18: goto tr51;
	case 3: goto tr3;
	case 19: goto tr56;
	case 20: goto tr3;
	case 4: goto tr6;
	case 21: goto tr58;
	case 22: goto tr59;
	case 23: goto tr39;
	case 24: goto tr39;
	case 25: goto tr39;
	case 26: goto tr39;
	case 27: goto tr67;
	case 28: goto tr3;
	case 29: goto tr67;
	case 30: goto tr67;
	case 31: goto tr67;
	case 32: goto tr67;
	case 33: goto tr67;
	case 34: goto tr39;
	case 5: goto tr0;
	case 35: goto tr75;
	case 6: goto tr3;
	case 36: goto tr67;
	case 37: goto tr3;
	case 38: goto tr67;
	case 39: goto tr67;
	case 40: goto tr67;
	case 41: goto tr67;
	case 42: goto tr67;
	}
	}

	_out: {}
	}

//#line 297 "scan.rl"
	
	at_bol = (last_token == T_NEWLINE) ? TRUE : FALSE;
	
	return last_token;
}


/*
* :Log: scan.rl,v $
* Revision 1.13  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.12  2014/02/09 10:16:15  pauloscustodio
* Remove complexity out of scan.rl by relying on srcfile to handle contexts of
* recursive includes, and reading of lines of text, and by assuming scan.c
* will not be reentred, simplifying the keeping of state variables for the scan.
*
* Revision 1.11  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.10  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.9  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.8  2014/01/10 00:15:27  pauloscustodio
* Use Str instead of glib, List instead of GSList.
* Use init.h mechanism, no need for main() calling init_scan.
* glib dependency removed from code and Makefile
*
* Revision 1.7  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.6  2013/11/11 23:47:04  pauloscustodio
* Move source code generation tools to dev/Makefile, only called on request,
* and keep the generated files in z80asm directory, so that build does
* not require tools used for the code generation (ragel, perl).
* Remove code generation for structs - use CLASS macro instead.
*
* Revision 1.5  2013/11/02 23:14:05  pauloscustodio
* g_slist_free_full() requires GLib 2.28, replaced by g_slist_foreach() and g_slist_free()
*
* Revision 1.4  2013/10/16 21:42:07  pauloscustodio
* Allocate minimum-sized string, grow as needed.
* Allocate a GString text inside of File, to be used by file reading methods.
*
* Revision 1.3  2013/10/16 00:14:37  pauloscustodio
* Move FileStack implementation to scan.c, remove FileStack.
* Move getline_File() to scan.c.
*
* Revision 1.2  2013/10/15 23:24:33  pauloscustodio
* Move reading by lines or tokens and file reading interface to scan.rl
* to decouple file.c from scan.c.
* Add singleton interface to scan to be used by parser.
*
* Revision 1.1  2013/10/08 21:53:06  pauloscustodio
* Replace Flex-based lexer by a Ragel-based one.
* Add interface to file.c to read files by tokens, calling the lexer.
*
*
*/
