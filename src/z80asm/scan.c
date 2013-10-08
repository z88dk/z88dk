
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

Copyright (C) Paulo Custodio, 2011-2013

Scanner - to be processed by: ragel -G2 scan.rl

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.c,v 1.22 2013-10-08 21:53:06 pauloscustodio Exp $ 
*/

#include "memalloc.h"   /* before any other include */

#include "scan.h"
#include "types.h"

static int scan_num(char *text, int num_suffix_chars, int base);

/*-----------------------------------------------------------------------------
* Globals that keep last token read
*----------------------------------------------------------------------------*/
enum token last_token;
int		   last_token_num;
GString	  *last_token_str;

/*-----------------------------------------------------------------------------
* Z80ASM scanner
*----------------------------------------------------------------------------*/




static const int asm_start = 5;
static const int asm_error = 0;

static const int asm_en_main = 5;



/*-----------------------------------------------------------------------------
* Initialize and Terminate module
*----------------------------------------------------------------------------*/
void init_scan(void)
{
	last_token_str = g_string_new("");
}
	
void fini_scan(void)
{
	g_string_free( last_token_str, TRUE );
	last_token_str = NULL;
}

/*-----------------------------------------------------------------------------
*	convert number to int, range warning if greater than INT_MAX
*----------------------------------------------------------------------------*/
static int scan_num (char *text, int length, int base)
{
	int value;
	int digit = 0;
	char c;
	int i;
	BOOL range_err;
	
	value = 0;
	range_err = FALSE;
	for ( i = 0 ; i < length ; i++ ) 
	{
		c = *text++;					/* read each digit */
		if (isdigit(c)) 
		{
			digit = c - '0';
		}
		else if (isalpha(c)) 
		{
			digit = toupper(c) - 'A' + 10;
		}
		else if (base == 2 && (c == '-' || c == '#')) 
		{
			digit = (c == '#') ? 1 : 0;
		}
		else {							/* invalid digit - should not be reached */
			error_syntax();
		}

		if (digit >= base) {			/* digit out of range - should not be reached */
			error_syntax();
		}
		
		value = value * base + digit;

		if ( ! range_err && value < 0 )	/* overflow to sign bit */
		{
			range_err = TRUE;		
			warn_int_range( value );
		}
	}
		
	return value;
}

/*-----------------------------------------------------------------------------
* Reset last token variables before each new scan
*----------------------------------------------------------------------------*/
static void reset_last_token(void)
{
	last_token = t_end;
	last_token_num = 0;
	g_string_truncate( last_token_str, 0 );
}

/*-----------------------------------------------------------------------------
* Get the scan position before a scan, to be able to set if afterwards to rollback
*----------------------------------------------------------------------------*/
int get_scan_pos( ScanState *self )
{
	return self->p - self->input->str;
}

void set_scan_pos( ScanState *self, int pos )
{
	self->p = CLAMP( self->input->str + pos,
					 self->input->str,
					 self->input->str + self->input->len );
	self->bol = (self->p == self->input->str) ? TRUE : FALSE;
}

/*-----------------------------------------------------------------------------
* Initialize the scanner to read the given string
*----------------------------------------------------------------------------*/
void start_scan( ScanState *self, GString *input )
{
	/* init state structure */
	self->input	= input;	
	self->bol   = TRUE;
	self->p		= input->str;
	self->pe	= input->str + input->len;
	self->eof	= self->pe;
	
	{
	(		self->cs) = asm_start;
	(		self->ts) = 0;
	(		self->te) = 0;
	(	self->act) = 0;
	}


	reset_last_token();
}

/*-----------------------------------------------------------------------------
* Insert new text to scan in the input at the current position
*----------------------------------------------------------------------------*/
void insert_to_scan( ScanState *self, char *new_text )
{
	char 	*old_str;
	gssize 	 pos;
	
	/* take note of old str pointer, string may be expanded and relocated by insertion */
	old_str = self->input->str;
	
	/* insert new text at p, surounded by spaces */
	pos = self->p - old_str;
	g_string_insert( self->input, pos, "  ");
	g_string_insert( self->input, pos + 1, new_text);
	
	/* relocate pointers if needed */
	if ( old_str != self->input->str )
	{
		int delta = self->input->str - old_str;
		self->p   += delta;
		self->ts  += delta;
		self->te  += delta;
	}
	
	/* recompute end */
	self->pe = self->eof = self->input->str + self->input->len;
}

/*-----------------------------------------------------------------------------
* Get the next token, set last_token, last_token_value as side-effect
*----------------------------------------------------------------------------*/
enum token get_token( ScanState *self )
{
	reset_last_token();
	
	
	{
	short _widec;
	if ( (		self->p) == (		self->pe) )
		goto _test_eof;
	switch ( (		self->cs) )
	{
tr0:
	{{(		self->p) = (((		self->te)))-1;}{ last_token = self->ts[0];	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr2:
	{(		self->te) = (		self->p)+1;{ 
		last_token_num = scan_num( self->ts + 2, self->te - self->ts - 3, 2 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr3:
	{	switch( (	self->act) ) {
	case 4:
	{{(		self->p) = (((		self->te)))-1;} last_token = self->ts[0];	{(		self->p)++; (		self->cs) = 5; goto _out;} }
	break;
	case 15:
	{{(		self->p) = (((		self->te)))-1;} 
		last_token_num = scan_num( self->ts, self->te - self->ts, 10 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}
	break;
	case 17:
	{{(		self->p) = (((		self->te)))-1;} 
		last_token_num = scan_num( self->ts + 1, self->te - self->ts - 1, 16 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}
	break;
	case 19:
	{{(		self->p) = (((		self->te)))-1;} 
		last_token_num = scan_num( self->ts, self->te - self->ts - 1, 2 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}
	break;
	case 21:
	{{(		self->p) = (((		self->te)))-1;} 
		last_token_num = scan_num( self->ts + 2, self->te - self->ts - 2, 2 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}
	break;
	}
	}
	goto st5;
tr5:
	{(		self->te) = (		self->p)+1;{ 
		last_token_num = scan_num( self->ts, self->te - self->ts - 1, 16 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr6:
	{{(		self->p) = (((		self->te)))-1;}{ 
		last_token_num = scan_num( self->ts, self->te - self->ts, 10 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr8:
	{(		self->te) = (		self->p)+1;}
	goto st5;
tr9:
	{(		self->te) = (		self->p)+1;{ 
		last_token = t_newline; 
		{(		self->p)++; (		self->cs) = 5; goto _out;} 
	}}
	goto st5;
tr16:
	{(		self->te) = (		self->p)+1;{ last_token = self->ts[0];	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr31:
	{(		self->te) = (		self->p);(		self->p)--;{ last_token = self->ts[0];	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr32:
	{(		self->te) = (		self->p)+1;{ last_token = t_exclam_eq; {(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr33:
	{(		self->te) = (		self->p);(		self->p)--;{ error_unclosed_string(); }}
	goto st5;
tr34:
	{(		self->te) = (		self->p)+1;{
		char c = *(self->te-1); *(self->te-1) = '\0';		/* make substring */
		g_string_assign( last_token_str, self->ts+1 );
		*(self->te-1) = c;									/* recover input */
		last_token = t_string;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr38:
	{(		self->te) = (		self->p);(		self->p)--;{ 
		last_token_num = scan_num( self->ts + 1, self->te - self->ts - 1, 2 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr39:
	{(		self->te) = (		self->p)+1;{ last_token = t_and_and; 	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr40:
	{(		self->te) = (		self->p);(		self->p)--;{ error_invalid_squoted_string(); }}
	goto st5;
tr41:
	{(		self->te) = (		self->p)+1;{
		if ( self->te - self->ts == 3 )
		{
			last_token_num = *(self->ts + 1);
			last_token = t_number;
			{(		self->p)++; (		self->cs) = 5; goto _out;}
		}
		else
			error_invalid_squoted_string();
	}}
	goto st5;
tr42:
	{(		self->te) = (		self->p)+1;{ last_token = t_star_star; {(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr43:
	{(		self->te) = (		self->p);(		self->p)--;{ 
		last_token_num = scan_num( self->ts, self->te - self->ts, 10 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr48:
	{(		self->te) = (		self->p);(		self->p)--;{ 
		last_token_num = scan_num( self->ts, self->te - self->ts - 1, 2 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr50:
	{(		self->te) = (		self->p);(		self->p)--;{ 
		last_token_num = scan_num( self->ts + 2, self->te - self->ts - 2, 16 ); 
		last_token = t_number;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr51:
	{(		self->te) = (		self->p);(		self->p)--;}
	goto st5;
tr52:
	{(		self->te) = (		self->p)+1;{ last_token = t_lt_lt; 	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr53:
	{(		self->te) = (		self->p)+1;{ last_token = t_lt_eq; 	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr54:
	{(		self->te) = (		self->p)+1;{ last_token = t_lt_gt; 	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr55:
	{(		self->te) = (		self->p)+1;{ last_token = t_eq_eq; 	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr56:
	{(		self->te) = (		self->p)+1;{ last_token = t_gt_eq; 	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr57:
	{(		self->te) = (		self->p)+1;{ last_token = t_gt_gt; 	{(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr58:
	{(		self->te) = (		self->p)+1;{ last_token = t_vbar_vbar; {(		self->p)++; (		self->cs) = 5; goto _out;} }}
	goto st5;
tr59:
	{(		self->te) = (		self->p);(		self->p)--;{
		char c = *(self->te); *(self->te) = '\0';		/* make substring */
		g_string_assign( last_token_str, self->ts );
		g_string_ascii_up( last_token_str );
		*(self->te) = c;								/* recover input */
		last_token = t_name;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr61:
	{(		self->te) = (		self->p)+1;{
		char c = *(self->te); *(self->te) = '\0';		/* make substring */
		g_string_assign( last_token_str, self->ts );
		g_string_ascii_up( last_token_str );
		*(self->te) = c;								/* recover input */
		last_token = t_name;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr63:
	{(		self->te) = (		self->p);(		self->p)--;{
		char *ts = self->ts;
		char *te = self->te;
		char c;
		
		/* remove '.' and ':' */
		if ( *ts     == '.' ) ts++;
		if ( *(te-1) == ':' ) te--;
		
		/* copy token */
		c = *te; *te = '\0';				/* make substring */
		g_string_assign( last_token_str, ts );
		g_string_ascii_up( last_token_str );
		*te = c;							/* recover input */
		last_token = t_label;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
tr64:
	{(		self->te) = (		self->p)+1;{
		char *ts = self->ts;
		char *te = self->te;
		char c;
		
		/* remove '.' and ':' */
		if ( *ts     == '.' ) ts++;
		if ( *(te-1) == ':' ) te--;
		
		/* copy token */
		c = *te; *te = '\0';				/* make substring */
		g_string_assign( last_token_str, ts );
		g_string_ascii_up( last_token_str );
		*te = c;							/* recover input */
		last_token = t_label;
		{(		self->p)++; (		self->cs) = 5; goto _out;}
	}}
	goto st5;
st5:
	{(		self->ts) = 0;}
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof5;
case 5:
	{(		self->ts) = (		self->p);}
	_widec = (*(		self->p));
	if ( (*(		self->p)) < 65 ) {
		if ( 46 <= (*(		self->p)) && (*(		self->p)) <= 46 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else if ( (*(		self->p)) > 90 ) {
		if ( (*(		self->p)) > 95 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 95 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		self->p)) - -128));
		if ( 
 self->bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 10: goto tr9;
		case 33: goto st6;
		case 34: goto st7;
		case 37: goto tr13;
		case 38: goto st11;
		case 39: goto st12;
		case 42: goto st13;
		case 47: goto tr16;
		case 48: goto tr19;
		case 59: goto st20;
		case 60: goto st21;
		case 61: goto st22;
		case 62: goto st23;
		case 64: goto tr13;
		case 96: goto tr16;
		case 124: goto st24;
		case 127: goto tr8;
		case 302: goto tr16;
		case 321: goto st25;
		case 351: goto st26;
		case 353: goto st25;
		case 558: goto st28;
		case 577: goto st30;
		case 607: goto st31;
		case 609: goto st30;
	}
	if ( _widec < 91 ) {
		if ( _widec < 40 ) {
			if ( _widec > 32 ) {
				if ( 35 <= _widec && _widec <= 36 )
					goto tr12;
			} else
				goto tr8;
		} else if ( _widec > 45 ) {
			if ( _widec > 57 ) {
				if ( 58 <= _widec && _widec <= 63 )
					goto tr16;
			} else if ( _widec >= 49 )
				goto tr20;
		} else
			goto tr16;
	} else if ( _widec > 94 ) {
		if ( _widec < 354 ) {
			if ( _widec > 126 ) {
				if ( 322 <= _widec && _widec <= 346 )
					goto st26;
			} else if ( _widec >= 123 )
				goto tr16;
		} else if ( _widec > 378 ) {
			if ( _widec > 602 ) {
				if ( 610 <= _widec && _widec <= 634 )
					goto st31;
			} else if ( _widec >= 578 )
				goto st31;
		} else
			goto st26;
	} else
		goto tr16;
	goto st0;
st6:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof6;
case 6:
	if ( (*(		self->p)) == 61 )
		goto tr32;
	goto tr31;
st7:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof7;
case 7:
	switch( (*(		self->p)) ) {
		case 10: goto tr33;
		case 34: goto tr34;
	}
	goto st7;
tr12:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 4;}
	goto st8;
tr35:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 17;}
	goto st8;
st8:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof8;
case 8:
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto tr35;
	} else if ( (*(		self->p)) > 70 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
			goto tr35;
	} else
		goto tr35;
	goto tr3;
tr13:
	{(		self->te) = (		self->p)+1;}
	goto st9;
st9:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof9;
case 9:
	if ( (*(		self->p)) == 34 )
		goto st1;
	if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 49 )
		goto st10;
	goto tr31;
st1:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof1;
case 1:
	switch( (*(		self->p)) ) {
		case 35: goto st2;
		case 45: goto st2;
	}
	goto tr0;
st2:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof2;
case 2:
	switch( (*(		self->p)) ) {
		case 34: goto tr2;
		case 35: goto st2;
		case 45: goto st2;
	}
	goto tr0;
st10:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof10;
case 10:
	if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 49 )
		goto st10;
	goto tr38;
st11:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof11;
case 11:
	if ( (*(		self->p)) == 38 )
		goto tr39;
	goto tr31;
st12:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof12;
case 12:
	switch( (*(		self->p)) ) {
		case 10: goto tr40;
		case 39: goto tr41;
	}
	goto st12;
st13:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof13;
case 13:
	if ( (*(		self->p)) == 42 )
		goto tr42;
	goto tr31;
st0:
(		self->cs) = 0;
	goto _out;
tr19:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 15;}
	goto st14;
st14:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof14;
case 14:
	switch( (*(		self->p)) ) {
		case 66: goto tr45;
		case 72: goto tr5;
		case 88: goto st4;
		case 98: goto tr45;
		case 104: goto tr5;
		case 120: goto st4;
	}
	if ( (*(		self->p)) < 50 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 49 )
			goto tr20;
	} else if ( (*(		self->p)) > 57 ) {
		if ( (*(		self->p)) > 70 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
				goto st3;
		} else if ( (*(		self->p)) >= 65 )
			goto st3;
	} else
		goto tr44;
	goto tr43;
tr20:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 15;}
	goto st15;
st15:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof15;
case 15:
	switch( (*(		self->p)) ) {
		case 66: goto tr47;
		case 72: goto tr5;
		case 98: goto tr47;
		case 104: goto tr5;
	}
	if ( (*(		self->p)) < 50 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 49 )
			goto tr20;
	} else if ( (*(		self->p)) > 57 ) {
		if ( (*(		self->p)) > 70 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
				goto st3;
		} else if ( (*(		self->p)) >= 65 )
			goto st3;
	} else
		goto tr44;
	goto tr43;
tr44:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 15;}
	goto st16;
st16:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof16;
case 16:
	switch( (*(		self->p)) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto tr44;
	} else if ( (*(		self->p)) > 70 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
			goto st3;
	} else
		goto st3;
	goto tr43;
st3:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof3;
case 3:
	switch( (*(		self->p)) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto st3;
	} else if ( (*(		self->p)) > 70 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
			goto st3;
	} else
		goto st3;
	goto tr3;
tr47:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 19;}
	goto st17;
st17:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof17;
case 17:
	switch( (*(		self->p)) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto st3;
	} else if ( (*(		self->p)) > 70 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
			goto st3;
	} else
		goto st3;
	goto tr48;
tr45:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 19;}
	goto st18;
tr49:
	{(		self->te) = (		self->p)+1;}
	{(	self->act) = 21;}
	goto st18;
st18:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof18;
case 18:
	switch( (*(		self->p)) ) {
		case 72: goto tr5;
		case 104: goto tr5;
	}
	if ( (*(		self->p)) < 50 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 49 )
			goto tr49;
	} else if ( (*(		self->p)) > 57 ) {
		if ( (*(		self->p)) > 70 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
				goto st3;
		} else if ( (*(		self->p)) >= 65 )
			goto st3;
	} else
		goto st3;
	goto tr3;
st4:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof4;
case 4:
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto st19;
	} else if ( (*(		self->p)) > 70 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
			goto st19;
	} else
		goto st19;
	goto tr6;
st19:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof19;
case 19:
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto st19;
	} else if ( (*(		self->p)) > 70 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 102 )
			goto st19;
	} else
		goto st19;
	goto tr50;
st20:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof20;
case 20:
	if ( (*(		self->p)) == 10 )
		goto tr51;
	goto st20;
st21:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof21;
case 21:
	switch( (*(		self->p)) ) {
		case 60: goto tr52;
		case 61: goto tr53;
		case 62: goto tr54;
	}
	goto tr31;
st22:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof22;
case 22:
	if ( (*(		self->p)) == 61 )
		goto tr55;
	goto tr31;
st23:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof23;
case 23:
	switch( (*(		self->p)) ) {
		case 61: goto tr56;
		case 62: goto tr57;
	}
	goto tr31;
st24:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof24;
case 24:
	if ( (*(		self->p)) == 124 )
		goto tr58;
	goto tr31;
st25:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof25;
case 25:
	switch( (*(		self->p)) ) {
		case 70: goto st27;
		case 95: goto st26;
		case 102: goto st27;
	}
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto st26;
	} else if ( (*(		self->p)) > 90 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 )
			goto st26;
	} else
		goto st26;
	goto tr59;
st26:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof26;
case 26:
	if ( (*(		self->p)) == 95 )
		goto st26;
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto st26;
	} else if ( (*(		self->p)) > 90 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 )
			goto st26;
	} else
		goto st26;
	goto tr59;
st27:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof27;
case 27:
	switch( (*(		self->p)) ) {
		case 39: goto tr61;
		case 95: goto st26;
	}
	if ( (*(		self->p)) < 65 ) {
		if ( 48 <= (*(		self->p)) && (*(		self->p)) <= 57 )
			goto st26;
	} else if ( (*(		self->p)) > 90 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 )
			goto st26;
	} else
		goto st26;
	goto tr59;
st28:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof28;
case 28:
	_widec = (*(		self->p));
	if ( (*(		self->p)) < 95 ) {
		if ( 65 <= (*(		self->p)) && (*(		self->p)) <= 90 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else if ( (*(		self->p)) > 95 ) {
		if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		self->p)) - -128));
		if ( 
 self->bol  ) _widec += 256;
	}
	if ( _widec == 607 )
		goto st29;
	if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st29;
	} else if ( _widec >= 577 )
		goto st29;
	goto tr31;
st29:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof29;
case 29:
	_widec = (*(		self->p));
	if ( (*(		self->p)) < 65 ) {
		if ( (*(		self->p)) > 57 ) {
			if ( 58 <= (*(		self->p)) && (*(		self->p)) <= 58 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 48 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else if ( (*(		self->p)) > 90 ) {
		if ( (*(		self->p)) > 95 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 95 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		self->p)) - -128));
		if ( 
 self->bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 570: goto tr64;
		case 607: goto st29;
	}
	if ( _widec < 577 ) {
		if ( 560 <= _widec && _widec <= 569 )
			goto st29;
	} else if ( _widec > 602 ) {
		if ( 609 <= _widec && _widec <= 634 )
			goto st29;
	} else
		goto st29;
	goto tr63;
st30:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof30;
case 30:
	_widec = (*(		self->p));
	if ( (*(		self->p)) < 65 ) {
		if ( (*(		self->p)) > 57 ) {
			if ( 58 <= (*(		self->p)) && (*(		self->p)) <= 58 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 48 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else if ( (*(		self->p)) > 90 ) {
		if ( (*(		self->p)) > 95 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 95 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		self->p)) - -128));
		if ( 
 self->bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 326: goto st27;
		case 351: goto st26;
		case 358: goto st27;
		case 570: goto tr64;
		case 582: goto st32;
		case 607: goto st31;
		case 614: goto st32;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto st26;
		} else if ( _widec >= 304 )
			goto st26;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto st31;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto st31;
		} else
			goto st31;
	} else
		goto st26;
	goto tr59;
st31:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof31;
case 31:
	_widec = (*(		self->p));
	if ( (*(		self->p)) < 65 ) {
		if ( (*(		self->p)) > 57 ) {
			if ( 58 <= (*(		self->p)) && (*(		self->p)) <= 58 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 48 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else if ( (*(		self->p)) > 90 ) {
		if ( (*(		self->p)) > 95 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 95 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		self->p)) - -128));
		if ( 
 self->bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 351: goto st26;
		case 570: goto tr64;
		case 607: goto st31;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto st26;
		} else if ( _widec >= 304 )
			goto st26;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto st31;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto st31;
		} else
			goto st31;
	} else
		goto st26;
	goto tr59;
st32:
	if ( ++(		self->p) == (		self->pe) )
		goto _test_eof32;
case 32:
	_widec = (*(		self->p));
	if ( (*(		self->p)) < 65 ) {
		if ( (*(		self->p)) > 57 ) {
			if ( 58 <= (*(		self->p)) && (*(		self->p)) <= 58 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 48 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else if ( (*(		self->p)) > 90 ) {
		if ( (*(		self->p)) > 95 ) {
			if ( 97 <= (*(		self->p)) && (*(		self->p)) <= 122 ) {
				_widec = (short)(128 + ((*(		self->p)) - -128));
				if ( 
 self->bol  ) _widec += 256;
			}
		} else if ( (*(		self->p)) >= 95 ) {
			_widec = (short)(128 + ((*(		self->p)) - -128));
			if ( 
 self->bol  ) _widec += 256;
		}
	} else {
		_widec = (short)(128 + ((*(		self->p)) - -128));
		if ( 
 self->bol  ) _widec += 256;
	}
	switch( _widec ) {
		case 39: goto tr61;
		case 351: goto st26;
		case 570: goto tr64;
		case 607: goto st31;
	}
	if ( _widec < 353 ) {
		if ( _widec > 313 ) {
			if ( 321 <= _widec && _widec <= 346 )
				goto st26;
		} else if ( _widec >= 304 )
			goto st26;
	} else if ( _widec > 378 ) {
		if ( _widec < 577 ) {
			if ( 560 <= _widec && _widec <= 569 )
				goto st31;
		} else if ( _widec > 602 ) {
			if ( 609 <= _widec && _widec <= 634 )
				goto st31;
		} else
			goto st31;
	} else
		goto st26;
	goto tr59;
	}
	_test_eof5: (		self->cs) = 5; goto _test_eof; 
	_test_eof6: (		self->cs) = 6; goto _test_eof; 
	_test_eof7: (		self->cs) = 7; goto _test_eof; 
	_test_eof8: (		self->cs) = 8; goto _test_eof; 
	_test_eof9: (		self->cs) = 9; goto _test_eof; 
	_test_eof1: (		self->cs) = 1; goto _test_eof; 
	_test_eof2: (		self->cs) = 2; goto _test_eof; 
	_test_eof10: (		self->cs) = 10; goto _test_eof; 
	_test_eof11: (		self->cs) = 11; goto _test_eof; 
	_test_eof12: (		self->cs) = 12; goto _test_eof; 
	_test_eof13: (		self->cs) = 13; goto _test_eof; 
	_test_eof14: (		self->cs) = 14; goto _test_eof; 
	_test_eof15: (		self->cs) = 15; goto _test_eof; 
	_test_eof16: (		self->cs) = 16; goto _test_eof; 
	_test_eof3: (		self->cs) = 3; goto _test_eof; 
	_test_eof17: (		self->cs) = 17; goto _test_eof; 
	_test_eof18: (		self->cs) = 18; goto _test_eof; 
	_test_eof4: (		self->cs) = 4; goto _test_eof; 
	_test_eof19: (		self->cs) = 19; goto _test_eof; 
	_test_eof20: (		self->cs) = 20; goto _test_eof; 
	_test_eof21: (		self->cs) = 21; goto _test_eof; 
	_test_eof22: (		self->cs) = 22; goto _test_eof; 
	_test_eof23: (		self->cs) = 23; goto _test_eof; 
	_test_eof24: (		self->cs) = 24; goto _test_eof; 
	_test_eof25: (		self->cs) = 25; goto _test_eof; 
	_test_eof26: (		self->cs) = 26; goto _test_eof; 
	_test_eof27: (		self->cs) = 27; goto _test_eof; 
	_test_eof28: (		self->cs) = 28; goto _test_eof; 
	_test_eof29: (		self->cs) = 29; goto _test_eof; 
	_test_eof30: (		self->cs) = 30; goto _test_eof; 
	_test_eof31: (		self->cs) = 31; goto _test_eof; 
	_test_eof32: (		self->cs) = 32; goto _test_eof; 

	_test_eof: {}
	if ( (		self->p) == (	self->eof) )
	{
	switch ( (		self->cs) ) {
	case 6: goto tr31;
	case 7: goto tr33;
	case 8: goto tr3;
	case 9: goto tr31;
	case 1: goto tr0;
	case 2: goto tr0;
	case 10: goto tr38;
	case 11: goto tr31;
	case 12: goto tr40;
	case 13: goto tr31;
	case 14: goto tr43;
	case 15: goto tr43;
	case 16: goto tr43;
	case 3: goto tr3;
	case 17: goto tr48;
	case 18: goto tr3;
	case 4: goto tr6;
	case 19: goto tr50;
	case 20: goto tr51;
	case 21: goto tr31;
	case 22: goto tr31;
	case 23: goto tr31;
	case 24: goto tr31;
	case 25: goto tr59;
	case 26: goto tr59;
	case 27: goto tr59;
	case 28: goto tr31;
	case 29: goto tr63;
	case 30: goto tr59;
	case 31: goto tr59;
	case 32: goto tr59;
	}
	}

	_out: {}
	}

	
	self->bol = (last_token == t_newline) ? TRUE : FALSE;
	
	return last_token;
}

/*
* $Log: scan.c,v $
* Revision 1.22  2013-10-08 21:53:06  pauloscustodio
* Replace Flex-based lexer by a Ragel-based one.
* Add interface to file.c to read files by tokens, calling the lexer.
*
*
*/
