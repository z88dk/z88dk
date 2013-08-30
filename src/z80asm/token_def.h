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
Copyright (C) Paulo Custodio, 2011-2013

Define lexer tokens

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/token_def.h,v 1.1 2013-08-30 01:06:08 pauloscustodio Exp $
*/

/* define list of tokens with corresponding string representation, 
   use a " " when not single-char token 
   newline must be the last token so that it is returned when a '\0' char is searched
		name,		legacy,	new		 */
#define SAME(x) x,x
TOKEN(	space, 		" ", " " )
TOKEN(	dquote, 	"\"","\"")
TOKEN(	squote, 	"'", "'" )
TOKEN(	colon,		" ", ":" )
TOKEN(	semicolon, 	";", ";" )
TOKEN(	comma, 		",", "," )
TOKEN(	fullstop, 	".", "." )
TOKEN(	lparen,		"(", "(" )
TOKEN(	lcurly,		"{", "{" )
TOKEN(	lsquare,	"[", "[" )
TOKEN(	rsquare,	"]", "]" )
TOKEN(	rcurly,		"}", "}" )
TOKEN(	rparen,		")", ")" )
TOKEN(	plus,		"+", "+" )
TOKEN(	minus,		"-", "-" )
TOKEN(	multiply,	"*", "*" )
TOKEN(	divi,		"/", "/" )
TOKEN(	mod,		"%", "%" )
TOKEN(	assign,		"=", "=" )
TOKEN(	bin_and,	"~", "&" )
TOKEN(	bin_or,		"|", "|" )
TOKEN(	bin_xor,	":", "^" )
TOKEN(	less,		"<", "<" )
TOKEN(	greater,	">", ">" )
TOKEN(	log_not,	"!", "!" )
TOKEN(	constexpr,	"#", "#" )
TOKEN(	power,		"^", " " )	/* ** */
TOKEN(	strconq,	"&", " " )
TOKEN(	bin_not,	" ", "~" )

/* not single-char */
TOKEN(	lessequal,	" ", " " )
TOKEN(	greatequal,	" ", " " )
TOKEN(	notequal,	" ", " " )
TOKEN(	name,		" ", " " )
TOKEN(	number,		" ", " " )
TOKEN(	decmconst,	" ", " " )
TOKEN(	hexconst,	" ", " " )
TOKEN(	binconst,	" ", " " )
TOKEN(	charconst,	" ", " " )
TOKEN(	negated,	" ", " " )
TOKEN(	nil,		" ", " " )
TOKEN(	ifstatm,	" ", " " )
TOKEN(	elsestatm,	" ", " " )
TOKEN(	endifstatm,	" ", " " )
TOKEN(	label,		" ", " " )
TOKEN(	newline,	"",  ""  )	/* must be last and empty string to match '\0' */

/* $Log: token_def.h,v $
/* Revision 1.1  2013-08-30 01:06:08  pauloscustodio
/* New C-like expressions, defined when LEGACY is not defined. Keeps old
/* behaviour under -DLEGACY (defined in legacy.h)
/*
/* BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-DLEGACY)
/* - Expressions now use more standard C-like operators
/* - Object and library files changed signature to
/*   "Z80RMF02", "Z80LMF02", to avoid usage of old
/*   object files with expressions inside in the old format
/*
/* Detail:
/* - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
/* - Power:                        changed from '^' to '**'; '^' will be XOR
/* - XOR:                          changed from ':' to '^';
/* - AND:                          changed from '~' to '&';  '~' will be NOT
/* - NOT:                          '~' added as binary not
/*
/*
/* */