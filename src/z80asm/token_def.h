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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/token_def.h,v 1.7 2013-10-15 23:24:33 pauloscustodio Exp $
*/

#ifndef TOKEN
#define TOKEN(name, str_legacy, str_new)
#endif

/* define list of tokens with corresponding string representation, 
   use a " " when not single-char token 
   newline must be the last token so that it is returned when a '\0' char is searched */
TOKEN(	nil,		" ", " " )
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
TOKEN(	ifstatm,	" ", " " )
TOKEN(	elsestatm,	" ", " " )
TOKEN(	endifstatm,	" ", " " )
TOKEN(	label,		" ", " " )
TOKEN(	string,		" ", " " )

/* must be last and empty string to match '\0' */
TOKEN(	newline,	"",  ""  )



#undef TOKEN

/*
* $Log: token_def.h,v $
* Revision 1.7  2013-10-15 23:24:33  pauloscustodio
* Move reading by lines or tokens and file reading interface to scan.rl
* to decouple file.c from scan.c.
* Add singleton interface to scan to be used by parser.
*
* Revision 1.6  2013/10/07 00:07:05  pauloscustodio
* log
*
* Revision 1.5  2013/10/07 00:06:18  pauloscustodio
* Create default empty TOKEN() macro if not defined
*
* Revision 1.4  2013/09/01 12:00:07  pauloscustodio
* Cleanup compilation warnings
*
* Revision 1.3  2013/08/30 21:50:43  pauloscustodio
* By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
* as an identifier reserved by the C standard for implementation-defined behaviour
* starting with two underscores.
*
* Revision 1.2  2013/08/30 01:11:54  pauloscustodio
* Symbols in symbol.h enum definition and in z80asm.c ssyms[] must be in the exact
* same order. Moreover need to define some different symbols for the legacy
* version.
*
* Move all defintions to token_def.h, included in both other files.
*
* Revision 1.1  2013/08/30 01:06:08  pauloscustodio
* New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX is not defined. Keeps old
* behaviour under -D__LEGACY_Z80ASM_SYNTAX (defined in legacy.h)
*
* BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
* - Expressions now use more standard C-like operators
* - Object and library files changed signature to
*   "Z80RMF02", "Z80LMF02", to avoid usage of old
*   object files with expressions inside in the old format
*
* Detail:
* - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
* - Power:                        changed from '^' to '**'; '^' will be XOR
* - XOR:                          changed from ':' to '^';
* - AND:                          changed from '~' to '&';  '~' will be NOT
* - NOT:                          '~' added as binary not
*
*/
