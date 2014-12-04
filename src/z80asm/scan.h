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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.h,v 1.37 2014-12-04 23:38:56 pauloscustodio Exp $
*/

#pragma once

#include "types.h"

/*-----------------------------------------------------------------------------
*	Token IDs
*----------------------------------------------------------------------------*/
#define TOKEN_RE(name, string, regexp, set_value)	name,
#define TOKEN(name, string, set_value)				name,
#define TOKEN2(name, string, set_value)

typedef enum tokid_t
{
#include "scan_def.h"
} tokid_t;

enum { FLAG_NONE = -1, FLAG_NZ, FLAG_Z, FLAG_NC, FLAG_C, FLAG_PO, FLAG_PE, FLAG_P, FLAG_M };
enum { REG8_NONE = -1, REG8_B, REG8_C, REG8_D, REG8_E, REG8_H, REG8_L, REG8_A = 7 };
enum { REG16_NONE = -1, REG16_BC, REG16_DE, REG16_HL, REG16_AF, REG16_SP = 3 };
enum { IND_REG16_NONE = -1, IND_REG16_BC, IND_REG16_DE, IND_REG16_HL };
enum { IDX_REG_HL = 0, IDX_REG_IX = 0xDD, IDX_REG_IY = 0xFD };

/*-----------------------------------------------------------------------------
* 	Globals - last token retrieved
*----------------------------------------------------------------------------*/
extern tokid_t tok;				/* current token */
extern char	  *tok_text;		/* contains characters of the retrieved token, only for
								   symbols used in the expression parser */
extern char   *tok_name;		/* contains identifier to return with TK_NAME and TK_LABEL */
extern char   *tok_string;		/* contains double-quoted string without quotes
								   to return with a TK_STRING */
extern long    tok_number;		/* contains number to return with TK_NUMBER */
extern int	   tok_flag;		/* FLAG_NONE, FLAG_NZ, FLAG_Z, FLAG_NC, FLAG_C, FLAG_PO, FLAG_PE, FLAG_P, FLAG_M */
extern int	   tok_reg8;		/* REG8_NONE, REG8_B, REG8_C, REG8_D, REG8_E, REG8_H, REG8_L, REG8_A */
extern int	   tok_reg16_af;	/* REG16_NONE, REG16_BC, REG16_DE, REG16_HL, REG16_AF */
extern int	   tok_reg16_sp;	/* REG16_NONE, REG16_BC, REG16_DE, REG16_HL, REG16_SP */
extern int	   tok_ind_reg16;	/* IND_REG16_NONE, IND_REG16_BC, IND_REG16_DE */
extern int     tok_idx_reg;		/* IDX_REG_HL, IDX_REG_IX, IDX_REG_IY */
extern int	   tok_ds_size;		/* DS.x size, 0 if none */

extern void  (*tok_parser)(void);	/* parser for this keyword as opcode */

extern Bool EOL;			/* scanner EOL state */

/*-----------------------------------------------------------------------------
*	Scan API
*----------------------------------------------------------------------------*/

/* get the next token, fill the corresponding tok* variables */
extern tokid_t GetSym( void );

/* get the current/next token, error if not the expected one */
extern void CurSymExpect(tokid_t expected_tok);
extern void GetSymExpect(tokid_t expected_tok);

/* insert the given text at the current scan position */
extern void SetTemporaryLine( char *line );

/* skip line past the newline, set EOL */
extern void  Skipline( void );
extern Bool EOL;
