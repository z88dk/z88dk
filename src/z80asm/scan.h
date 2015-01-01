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

Scanner. Scanning engine is built by ragel from scan_rules.rl.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.h,v 1.48 2015-01-01 02:34:23 pauloscustodio Exp $
*/

#pragma once

#include "legacy.h"
#include "scan_tokens.h"
#include "types.h"
#include "opcodes.h"

#ifdef __LEGACY_Z80ASM_SYNTAX
#define TK_QUESTION		TK_INVALID
#define TK_COLON		TK_INVALID
#define TK_BIN_NOT		TK_INVALID
#else
#define TK_STRING_CAT	TK_COMMA
#endif

/*-----------------------------------------------------------------------------
* 	Keep last symbol retrieved
*----------------------------------------------------------------------------*/
typedef struct sym_t 
{
	tokid_t  tok;			/* token */
	char	*text;			/* characters of the retrieved token for lexemes 
							*  used in the expression parser */
	char	*string;		/* identifier to return with TK_NAME and TK_LABEL, or
							*  double-quoted string without quotes to return with a TK_STRING */
	char	*ts, *te;		/* Ragel's token start and token end */
	char	*filename;		/* filename where token found, in strpool */
	int 	 line_nr;		/* line number where token found */
	int		 number;		/* number to return with TK_NUMBER */
	int		 ds_size;		/* DS.x size, 0 if none */
} Sym;

/*-----------------------------------------------------------------------------
* 	Globals
*----------------------------------------------------------------------------*/
extern Sym  sym;			/* last token retrieved */
extern Bool EOL;			/* scanner EOL state */

/*-----------------------------------------------------------------------------
*	Scan API
*----------------------------------------------------------------------------*/

/* get the next token, fill the corresponding tok* variables */
extern tokid_t GetSym( void );
extern void scan_expect_opcode(void);		/* GetSym() returns NOP as TK_NOP */
extern void scan_expect_operands(void);		/* GetSym() returns NOP as TK_NAME */

/* save the current scan position and back-track to a saved position */
extern void save_scan_state(void);		/* needs to be balanced with restore_.../drop_... */
extern void restore_scan_state(void);
extern void drop_scan_state(void);

/* get the current/next token, error if not the expected one */
extern void CurSymExpect(tokid_t expected_tok);
extern void GetSymExpect(tokid_t expected_tok);

/* insert the given text at the current scan position */
extern void SetTemporaryLine( char *line );

/* skip line past the newline, set EOL */
extern void  Skipline( void );
extern Bool EOL;
