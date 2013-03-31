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

Scanner - to be processed by: flex -L scan.l
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/scan.c,v 1.2 2013-03-31 18:28:30 pauloscustodio Exp $ */
/* $Log: scan.c,v $
/* Revision 1.2  2013-03-31 18:28:30  pauloscustodio
/* New TOK_LABEL for a label definition, i.e. ". NAME" or "NAME :"
/*
/* Revision 1.1  2013/03/29 23:53:08  pauloscustodio
/* Added GNU Flex-based scanner. Not yet integrated into assembler.
/*
/*
/* */

#include "memalloc.h"	/* before any other include */

#define YY_NO_UNISTD_H	1		/* don't include unistd */

#ifndef SCAN_H
#define SCAN_H

#include "class.h"
#include "classlist.h"
#include "dynstr.h"

/*-----------------------------------------------------------------------------
*   Token Type
*----------------------------------------------------------------------------*/
typedef enum TokType
{
	/* mark end of input */
	TOK_NULL			= 0,
	
    /* single character tokens */
    TOK_NEWLINE         = '\n',
	
    TOK_EXCLAM          = '!',
    TOK_HASH            = '#',
    TOK_DOLLAR          = '$',
    TOK_PERCENT         = '%',
    TOK_AMPERSAND       = '&',
    TOK_LPAREN          = '(',
    TOK_RPAREN          = ')',
    TOK_ASTERISK        = '*',
    TOK_PLUS            = '+',
    TOK_COMMA           = ',',
    TOK_HYPHEN          = '-',
    TOK_PERIOD          = '.',
    TOK_SLASH           = '/',
    TOK_COLON           = ':',
    TOK_LESS            = '<',
    TOK_EQUAL           = '=',
    TOK_GREATER         = '>',
    TOK_QUESTION        = '?',
    TOK_ATSIGN          = '@',
    TOK_LSQUARE         = '[',
    TOK_BACKSLASH       = '\\',
    TOK_RSQUARE         = ']',
    TOK_CARET           = '^',
    TOK_BACKQUOTE       = '`',
    TOK_LCURLY          = '{',
    TOK_VBAR            = '|',
    TOK_RCURLY          = '}',
    TOK_TILDE           = '~',
	
    /* multi-character tokens */
    TOK_EQUAL_EQUAL     = 0x100,/* "==" */
    TOK_LESS_GREATER,           /* "<>" */
    TOK_NOT_EQUAL,              /* "!=" */
    TOK_LESS_EQUAL,             /* "<=" */
    TOK_GREATER_EQUAL,          /* ">=" */
    TOK_DBL_VBAR,               /* "||" */
    TOK_DBL_AMPERSAND,          /* "&&" */
    TOK_DBL_LESS,               /* "<<" */
    TOK_DBL_GREATER,            /* ">>" */
    TOK_DBL_ASTERISK,           /* "**" */

    /* language tokens */
    TOK_NAME,                   /* any identifier */
    TOK_LABEL,                  /* label definition, i.e. ". NAME" or "NAME :" */
    TOK_NUMBER,
    TOK_STRING,                 /* single- or double-quoted string */
    TOK_PREPROC,                /* preprocessor command */

} TokType;

/*-----------------------------------------------------------------------------
*   Token and list of tokens
*----------------------------------------------------------------------------*/
CLASS(Token)
	TokType	tok_type;			/* type of token */
	long	num_value;			/* numeric value, if any */
	Str	   *str_value;			/* string value, if any */
	char   *filename;			/* file name - kept in strpool */
	int 	line_nr;			/* input line number */
END_CLASS;

CLASS_LIST(Token);

/*-----------------------------------------------------------------------------
*   API - uses srcfile.h singleton API
*----------------------------------------------------------------------------*/

/* Start reading file / text at current position */
extern void scan_file( char *filename );
extern void scan_text( char *text );

/* scan input for next token, return token type; 
   use scan_xxx() to last returned token attributes, only valid until next
   scan_get()/scan_unget() call */
extern TokType scan_get( void );
extern TokType scan_tok_type( void );
extern long	   scan_num_value( void );
extern char   *scan_str_value( void );
extern char   *scan_filename( void );
extern int 	   scan_line_nr( void );

/* push back token to input stream */
extern void scan_unget( TokType tok_type, long num_value, char *str_value,
						char *filename, int line_nr );

/* stack of nested constructs, i.e. IF / ELSE / ENDIF
   local to each input file, stack must be empty at the end of file */
extern void scan_push_struct( int id, int value );
extern int  scan_top_id( void );						
extern int  scan_top_value( void );
extern void scan_replace_struct( int id, int value );
extern void scan_pop_struct( int id );		/* syntaxt error if id != top_id */

/* forward declaration for YY_EXTRA_TYPE */
struct Context;

#endif /* ndef SCAN_H */





#define  YY_INT_ALIGNED long int

/* A lexical scanner generated by flex */

#define FLEX_SCANNER
#define YY_FLEX_MAJOR_VERSION 2
#define YY_FLEX_MINOR_VERSION 5
#define YY_FLEX_SUBMINOR_VERSION 35
#if YY_FLEX_SUBMINOR_VERSION > 0
#define FLEX_BETA
#endif

/* First, we deal with  platform-specific or compiler-specific issues. */

/* begin standard C headers. */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

/* end standard C headers. */

/* flex integer type definitions */

#ifndef FLEXINT_H
#define FLEXINT_H

/* C99 systems have <inttypes.h>. Non-C99 systems may or may not. */

#if defined (__STDC_VERSION__) && __STDC_VERSION__ >= 199901L

/* C99 says to define __STDC_LIMIT_MACROS before including stdint.h,
 * if you want the limit (max/min) macros for int types. 
 */
#ifndef __STDC_LIMIT_MACROS
#define __STDC_LIMIT_MACROS 1
#endif

#include <inttypes.h>
typedef int8_t flex_int8_t;
typedef uint8_t flex_uint8_t;
typedef int16_t flex_int16_t;
typedef uint16_t flex_uint16_t;
typedef int32_t flex_int32_t;
typedef uint32_t flex_uint32_t;
#else
typedef signed char flex_int8_t;
typedef short int flex_int16_t;
typedef int flex_int32_t;
typedef unsigned char flex_uint8_t; 
typedef unsigned short int flex_uint16_t;
typedef unsigned int flex_uint32_t;

/* Limits of integral types. */
#ifndef INT8_MIN
#define INT8_MIN               (-128)
#endif
#ifndef INT16_MIN
#define INT16_MIN              (-32767-1)
#endif
#ifndef INT32_MIN
#define INT32_MIN              (-2147483647-1)
#endif
#ifndef INT8_MAX
#define INT8_MAX               (127)
#endif
#ifndef INT16_MAX
#define INT16_MAX              (32767)
#endif
#ifndef INT32_MAX
#define INT32_MAX              (2147483647)
#endif
#ifndef UINT8_MAX
#define UINT8_MAX              (255U)
#endif
#ifndef UINT16_MAX
#define UINT16_MAX             (65535U)
#endif
#ifndef UINT32_MAX
#define UINT32_MAX             (4294967295U)
#endif

#endif /* ! C99 */

#endif /* ! FLEXINT_H */

#ifdef __cplusplus

/* The "const" storage-class-modifier is valid. */
#define YY_USE_CONST

#else	/* ! __cplusplus */

/* C99 requires __STDC__ to be defined as 1. */
#if defined (__STDC__)

#define YY_USE_CONST

#endif	/* defined (__STDC__) */
#endif	/* ! __cplusplus */

#ifdef YY_USE_CONST
#define yyconst const
#else
#define yyconst
#endif

/* Returned upon end-of-file. */
#define YY_NULL 0

/* Promotes a possibly negative, possibly signed char to an unsigned
 * integer for use as an array index.  If the signed char is negative,
 * we want to instead treat it as an 8-bit unsigned char, hence the
 * double cast.
 */
#define YY_SC_TO_UI(c) ((unsigned int) (unsigned char) c)

/* An opaque pointer. */
#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif

/* For convenience, these vars (plus the bison vars far below)
   are macros in the reentrant scanner. */
#define yyin yyg->yyin_r
#define yyout yyg->yyout_r
#define yyextra yyg->yyextra_r
#define yyleng yyg->yyleng_r
#define yytext yyg->yytext_r
#define yylineno (YY_CURRENT_BUFFER_LVALUE->yy_bs_lineno)
#define yycolumn (YY_CURRENT_BUFFER_LVALUE->yy_bs_column)
#define yy_flex_debug yyg->yy_flex_debug_r

/* Enter a start condition.  This macro really ought to take a parameter,
 * but we do it the disgusting crufty way forced on us by the ()-less
 * definition of BEGIN.
 */
#define BEGIN yyg->yy_start = 1 + 2 *

/* Translate the current start state into a value that can be later handed
 * to BEGIN to return to the state.  The YYSTATE alias is for lex
 * compatibility.
 */
#define YY_START ((yyg->yy_start - 1) / 2)
#define YYSTATE YY_START

/* Action number for EOF rule of a given start state. */
#define YY_STATE_EOF(state) (YY_END_OF_BUFFER + state + 1)

/* Special action meaning "start processing a new file". */
#define YY_NEW_FILE yyrestart(yyin ,yyscanner )

#define YY_END_OF_BUFFER_CHAR 0

/* Size of default input buffer. */
#ifndef YY_BUF_SIZE
#ifdef __ia64__
/* On IA-64, the buffer size is 16k, not 8k.
 * Moreover, YY_BUF_SIZE is 2*YY_READ_BUF_SIZE in the general case.
 * Ditto for the __ia64__ case accordingly.
 */
#define YY_BUF_SIZE 32768
#else
#define YY_BUF_SIZE 16384
#endif /* __ia64__ */
#endif

/* The state buf must be large enough to hold one state per character in the main buffer.
 */
#define YY_STATE_BUF_SIZE   ((YY_BUF_SIZE + 2) * sizeof(yy_state_type))

#ifndef YY_TYPEDEF_YY_BUFFER_STATE
#define YY_TYPEDEF_YY_BUFFER_STATE
typedef struct yy_buffer_state *YY_BUFFER_STATE;
#endif

#define EOB_ACT_CONTINUE_SCAN 0
#define EOB_ACT_END_OF_FILE 1
#define EOB_ACT_LAST_MATCH 2

    #define YY_LESS_LINENO(n)
    
/* Return all but the first "n" matched characters back to the input stream. */
#define yyless(n) \
	do \
		{ \
		/* Undo effects of setting up yytext. */ \
        int yyless_macro_arg = (n); \
        YY_LESS_LINENO(yyless_macro_arg);\
		*yy_cp = yyg->yy_hold_char; \
		YY_RESTORE_YY_MORE_OFFSET \
		yyg->yy_c_buf_p = yy_cp = yy_bp + yyless_macro_arg - YY_MORE_ADJ; \
		YY_DO_BEFORE_ACTION; /* set up yytext again */ \
		} \
	while ( 0 )

#define unput(c) yyunput( c, yyg->yytext_ptr , yyscanner )

#ifndef YY_TYPEDEF_YY_SIZE_T
#define YY_TYPEDEF_YY_SIZE_T
typedef size_t yy_size_t;
#endif

#ifndef YY_STRUCT_YY_BUFFER_STATE
#define YY_STRUCT_YY_BUFFER_STATE
struct yy_buffer_state
	{
	FILE *yy_input_file;

	char *yy_ch_buf;		/* input buffer */
	char *yy_buf_pos;		/* current position in input buffer */

	/* Size of input buffer in bytes, not including room for EOB
	 * characters.
	 */
	yy_size_t yy_buf_size;

	/* Number of characters read into yy_ch_buf, not including EOB
	 * characters.
	 */
	int yy_n_chars;

	/* Whether we "own" the buffer - i.e., we know we created it,
	 * and can realloc() it to grow it, and should free() it to
	 * delete it.
	 */
	int yy_is_our_buffer;

	/* Whether this is an "interactive" input source; if so, and
	 * if we're using stdio for input, then we want to use getc()
	 * instead of fread(), to make sure we stop fetching input after
	 * each newline.
	 */
	int yy_is_interactive;

	/* Whether we're considered to be at the beginning of a line.
	 * If so, '^' rules will be active on the next match, otherwise
	 * not.
	 */
	int yy_at_bol;

    int yy_bs_lineno; /**< The line count. */
    int yy_bs_column; /**< The column count. */
    
	/* Whether to try to fill the input buffer when we reach the
	 * end of it.
	 */
	int yy_fill_buffer;

	int yy_buffer_status;

#define YY_BUFFER_NEW 0
#define YY_BUFFER_NORMAL 1
	/* When an EOF's been seen but there's still some text to process
	 * then we mark the buffer as YY_EOF_PENDING, to indicate that we
	 * shouldn't try reading from the input source any more.  We might
	 * still have a bunch of tokens to match, though, because of
	 * possible backing-up.
	 *
	 * When we actually see the EOF, we change the status to "new"
	 * (via yyrestart()), so that the user can continue scanning by
	 * just pointing yyin at a new input file.
	 */
#define YY_BUFFER_EOF_PENDING 2

	};
#endif /* !YY_STRUCT_YY_BUFFER_STATE */

/* We provide macros for accessing buffer states in case in the
 * future we want to put the buffer states in a more general
 * "scanner state".
 *
 * Returns the top of the stack, or NULL.
 */
#define YY_CURRENT_BUFFER ( yyg->yy_buffer_stack \
                          ? yyg->yy_buffer_stack[yyg->yy_buffer_stack_top] \
                          : NULL)

/* Same as previous macro, but useful when we know that the buffer stack is not
 * NULL or when we need an lvalue. For internal use only.
 */
#define YY_CURRENT_BUFFER_LVALUE yyg->yy_buffer_stack[yyg->yy_buffer_stack_top]

void yyrestart (FILE *input_file ,yyscan_t yyscanner );
void yy_switch_to_buffer (YY_BUFFER_STATE new_buffer ,yyscan_t yyscanner );
YY_BUFFER_STATE yy_create_buffer (FILE *file,int size ,yyscan_t yyscanner );
void yy_delete_buffer (YY_BUFFER_STATE b ,yyscan_t yyscanner );
void yy_flush_buffer (YY_BUFFER_STATE b ,yyscan_t yyscanner );
void yypush_buffer_state (YY_BUFFER_STATE new_buffer ,yyscan_t yyscanner );
void yypop_buffer_state (yyscan_t yyscanner );

static void yyensure_buffer_stack (yyscan_t yyscanner );
static void yy_load_buffer_state (yyscan_t yyscanner );
static void yy_init_buffer (YY_BUFFER_STATE b,FILE *file ,yyscan_t yyscanner );

#define YY_FLUSH_BUFFER yy_flush_buffer(YY_CURRENT_BUFFER ,yyscanner)

YY_BUFFER_STATE yy_scan_buffer (char *base,yy_size_t size ,yyscan_t yyscanner );
YY_BUFFER_STATE yy_scan_string (yyconst char *yy_str ,yyscan_t yyscanner );
YY_BUFFER_STATE yy_scan_bytes (yyconst char *bytes,int len ,yyscan_t yyscanner );

void *yyalloc (yy_size_t ,yyscan_t yyscanner );
void *yyrealloc (void *,yy_size_t ,yyscan_t yyscanner );
void yyfree (void * ,yyscan_t yyscanner );

#define yy_new_buffer yy_create_buffer

#define yy_set_interactive(is_interactive) \
	{ \
	if ( ! YY_CURRENT_BUFFER ){ \
        yyensure_buffer_stack (yyscanner); \
		YY_CURRENT_BUFFER_LVALUE =    \
            yy_create_buffer(yyin,YY_BUF_SIZE ,yyscanner); \
	} \
	YY_CURRENT_BUFFER_LVALUE->yy_is_interactive = is_interactive; \
	}

#define yy_set_bol(at_bol) \
	{ \
	if ( ! YY_CURRENT_BUFFER ){\
        yyensure_buffer_stack (yyscanner); \
		YY_CURRENT_BUFFER_LVALUE =    \
            yy_create_buffer(yyin,YY_BUF_SIZE ,yyscanner); \
	} \
	YY_CURRENT_BUFFER_LVALUE->yy_at_bol = at_bol; \
	}

#define YY_AT_BOL() (YY_CURRENT_BUFFER_LVALUE->yy_at_bol)

/* Begin user sect3 */

#define yywrap(n) 1
#define YY_SKIP_YYWRAP

typedef unsigned char YY_CHAR;

typedef yyconst struct yy_trans_info *yy_state_type;

#define yytext_ptr yytext_r

static yy_state_type yy_get_previous_state (yyscan_t yyscanner );
static yy_state_type yy_try_NUL_trans (yy_state_type current_state  ,yyscan_t yyscanner);
static int yy_get_next_buffer (yyscan_t yyscanner );
static void yy_fatal_error (yyconst char msg[] ,yyscan_t yyscanner );

/* Done after the current pattern has been matched and before the
 * corresponding action - sets up yytext.
 */
#define YY_DO_BEFORE_ACTION \
	yyg->yytext_ptr = yy_bp; \
	yyleng = (size_t) (yy_cp - yy_bp); \
	yyg->yy_hold_char = *yy_cp; \
	*yy_cp = '\0'; \
	yyg->yy_c_buf_p = yy_cp;

#define YY_NUM_RULES 32
#define YY_END_OF_BUFFER 33
struct yy_trans_info
	{
	flex_int32_t yy_verify;
	flex_int32_t yy_nxt;
	};
static yyconst struct yy_trans_info yy_transition[6339] =
    {
 {   0,   0 }, {   0,6083 }, {   0,   0 }, {   0,6081 }, {   1,1032 },
 {   2,1032 }, {   3,1032 }, {   4,1032 }, {   5,1032 }, {   6,1032 },
 {   7,1032 }, {   8,1032 }, {   9,1034 }, {  10,1036 }, {  11,1032 },
 {  12,1034 }, {  13,1038 }, {  14,1032 }, {  15,1032 }, {  16,1032 },
 {  17,1032 }, {  18,1032 }, {  19,1032 }, {  20,1032 }, {  21,1032 },
 {  22,1032 }, {  23,1032 }, {  24,1032 }, {  25,1032 }, {  26,1032 },
 {  27,1032 }, {  28,1032 }, {  29,1032 }, {  30,1032 }, {  31,1032 },
 {  32,1034 }, {  33,1064 }, {  34,1158 }, {  35,1416 }, {  36,1416 },
 {  37,1440 }, {  38,1442 }, {  39,1520 }, {  40,1032 }, {  41,1032 },
 {  42,1445 }, {  43,1032 }, {  44,1032 }, {  45,1032 }, {  46,1778 },

 {  47,1032 }, {  48,1870 }, {  49,1929 }, {  50,1988 }, {  51,1988 },
 {  52,1988 }, {  53,1988 }, {  54,1988 }, {  55,1988 }, {  56,1988 },
 {  57,1988 }, {  58,1032 }, {  59,2094 }, {  60,1447 }, {  61,1449 },
 {  62,1780 }, {  63,1032 }, {  64,1440 }, {  65,2352 }, {  66,2476 },
 {  67,2476 }, {  68,2476 }, {  69,2476 }, {  70,2476 }, {  71,2476 },
 {  72,2476 }, {  73,2476 }, {  74,2476 }, {  75,2476 }, {  76,2476 },
 {  77,2476 }, {  78,2476 }, {  79,2476 }, {  80,2476 }, {  81,2476 },
 {  82,2476 }, {  83,2476 }, {  84,2476 }, {  85,2476 }, {  86,2476 },
 {  87,2476 }, {  88,2476 }, {  89,2476 }, {  90,2476 }, {  91,1032 },
 {  92,1032 }, {  93,1032 }, {  94,1032 }, {  95,2476 }, {  96,1032 },

 {  97,2352 }, {  98,2476 }, {  99,2476 }, { 100,2476 }, { 101,2476 },
 { 102,2476 }, { 103,2476 }, { 104,2476 }, { 105,2476 }, { 106,2476 },
 { 107,2476 }, { 108,2476 }, { 109,2476 }, { 110,2476 }, { 111,2476 },
 { 112,2476 }, { 113,2476 }, { 114,2476 }, { 115,2476 }, { 116,2476 },
 { 117,2476 }, { 118,2476 }, { 119,2476 }, { 120,2476 }, { 121,2476 },
 { 122,2476 }, { 123,1032 }, { 124,1782 }, { 125,1032 }, { 126,1032 },
 { 127,1032 }, { 128,1032 }, { 129,1032 }, { 130,1032 }, { 131,1032 },
 { 132,1032 }, { 133,1032 }, { 134,1032 }, { 135,1032 }, { 136,1032 },
 { 137,1032 }, { 138,1032 }, { 139,1032 }, { 140,1032 }, { 141,1032 },
 { 142,1032 }, { 143,1032 }, { 144,1032 }, { 145,1032 }, { 146,1032 },

 { 147,1032 }, { 148,1032 }, { 149,1032 }, { 150,1032 }, { 151,1032 },
 { 152,1032 }, { 153,1032 }, { 154,1032 }, { 155,1032 }, { 156,1032 },
 { 157,1032 }, { 158,1032 }, { 159,1032 }, { 160,1032 }, { 161,1032 },
 { 162,1032 }, { 163,1032 }, { 164,1032 }, { 165,1032 }, { 166,1032 },
 { 167,1032 }, { 168,1032 }, { 169,1032 }, { 170,1032 }, { 171,1032 },
 { 172,1032 }, { 173,1032 }, { 174,1032 }, { 175,1032 }, { 176,1032 },
 { 177,1032 }, { 178,1032 }, { 179,1032 }, { 180,1032 }, { 181,1032 },
 { 182,1032 }, { 183,1032 }, { 184,1032 }, { 185,1032 }, { 186,1032 },
 { 187,1032 }, { 188,1032 }, { 189,1032 }, { 190,1032 }, { 191,1032 },
 { 192,1032 }, { 193,1032 }, { 194,1032 }, { 195,1032 }, { 196,1032 },

 { 197,1032 }, { 198,1032 }, { 199,1032 }, { 200,1032 }, { 201,1032 },
 { 202,1032 }, { 203,1032 }, { 204,1032 }, { 205,1032 }, { 206,1032 },
 { 207,1032 }, { 208,1032 }, { 209,1032 }, { 210,1032 }, { 211,1032 },
 { 212,1032 }, { 213,1032 }, { 214,1032 }, { 215,1032 }, { 216,1032 },
 { 217,1032 }, { 218,1032 }, { 219,1032 }, { 220,1032 }, { 221,1032 },
 { 222,1032 }, { 223,1032 }, { 224,1032 }, { 225,1032 }, { 226,1032 },
 { 227,1032 }, { 228,1032 }, { 229,1032 }, { 230,1032 }, { 231,1032 },
 { 232,1032 }, { 233,1032 }, { 234,1032 }, { 235,1032 }, { 236,1032 },
 { 237,1032 }, { 238,1032 }, { 239,1032 }, { 240,1032 }, { 241,1032 },
 { 242,1032 }, { 243,1032 }, { 244,1032 }, { 245,1032 }, { 246,1032 },

 { 247,1032 }, { 248,1032 }, { 249,1032 }, { 250,1032 }, { 251,1032 },
 { 252,1032 }, { 253,1032 }, { 254,1032 }, { 255,1032 }, { 256,1032 },
 {   0,   0 }, {   0,5823 }, {   1, 774 }, {   2, 774 }, {   3, 774 },
 {   4, 774 }, {   5, 774 }, {   6, 774 }, {   7, 774 }, {   8, 774 },
 {   9, 776 }, {  10, 778 }, {  11, 774 }, {  12, 776 }, {  13, 780 },
 {  14, 774 }, {  15, 774 }, {  16, 774 }, {  17, 774 }, {  18, 774 },
 {  19, 774 }, {  20, 774 }, {  21, 774 }, {  22, 774 }, {  23, 774 },
 {  24, 774 }, {  25, 774 }, {  26, 774 }, {  27, 774 }, {  28, 774 },
 {  29, 774 }, {  30, 774 }, {  31, 774 }, {  32, 776 }, {  33, 806 },
 {  34, 900 }, {  35,1158 }, {  36,1158 }, {  37,1182 }, {  38,1184 },

 {  39,1262 }, {  40, 774 }, {  41, 774 }, {  42,1187 }, {  43, 774 },
 {  44, 774 }, {  45, 774 }, {  46,1520 }, {  47, 774 }, {  48,1612 },
 {  49,1671 }, {  50,1730 }, {  51,1730 }, {  52,1730 }, {  53,1730 },
 {  54,1730 }, {  55,1730 }, {  56,1730 }, {  57,1730 }, {  58, 774 },
 {  59,1836 }, {  60,1189 }, {  61,1191 }, {  62,1522 }, {  63, 774 },
 {  64,1182 }, {  65,2094 }, {  66,2218 }, {  67,2218 }, {  68,2218 },
 {  69,2218 }, {  70,2218 }, {  71,2218 }, {  72,2218 }, {  73,2218 },
 {  74,2218 }, {  75,2218 }, {  76,2218 }, {  77,2218 }, {  78,2218 },
 {  79,2218 }, {  80,2218 }, {  81,2218 }, {  82,2218 }, {  83,2218 },
 {  84,2218 }, {  85,2218 }, {  86,2218 }, {  87,2218 }, {  88,2218 },

 {  89,2218 }, {  90,2218 }, {  91, 774 }, {  92, 774 }, {  93, 774 },
 {  94, 774 }, {  95,2218 }, {  96, 774 }, {  97,2094 }, {  98,2218 },
 {  99,2218 }, { 100,2218 }, { 101,2218 }, { 102,2218 }, { 103,2218 },
 { 104,2218 }, { 105,2218 }, { 106,2218 }, { 107,2218 }, { 108,2218 },
 { 109,2218 }, { 110,2218 }, { 111,2218 }, { 112,2218 }, { 113,2218 },
 { 114,2218 }, { 115,2218 }, { 116,2218 }, { 117,2218 }, { 118,2218 },
 { 119,2218 }, { 120,2218 }, { 121,2218 }, { 122,2218 }, { 123, 774 },
 { 124,1524 }, { 125, 774 }, { 126, 774 }, { 127, 774 }, { 128, 774 },
 { 129, 774 }, { 130, 774 }, { 131, 774 }, { 132, 774 }, { 133, 774 },
 { 134, 774 }, { 135, 774 }, { 136, 774 }, { 137, 774 }, { 138, 774 },

 { 139, 774 }, { 140, 774 }, { 141, 774 }, { 142, 774 }, { 143, 774 },
 { 144, 774 }, { 145, 774 }, { 146, 774 }, { 147, 774 }, { 148, 774 },
 { 149, 774 }, { 150, 774 }, { 151, 774 }, { 152, 774 }, { 153, 774 },
 { 154, 774 }, { 155, 774 }, { 156, 774 }, { 157, 774 }, { 158, 774 },
 { 159, 774 }, { 160, 774 }, { 161, 774 }, { 162, 774 }, { 163, 774 },
 { 164, 774 }, { 165, 774 }, { 166, 774 }, { 167, 774 }, { 168, 774 },
 { 169, 774 }, { 170, 774 }, { 171, 774 }, { 172, 774 }, { 173, 774 },
 { 174, 774 }, { 175, 774 }, { 176, 774 }, { 177, 774 }, { 178, 774 },
 { 179, 774 }, { 180, 774 }, { 181, 774 }, { 182, 774 }, { 183, 774 },
 { 184, 774 }, { 185, 774 }, { 186, 774 }, { 187, 774 }, { 188, 774 },

 { 189, 774 }, { 190, 774 }, { 191, 774 }, { 192, 774 }, { 193, 774 },
 { 194, 774 }, { 195, 774 }, { 196, 774 }, { 197, 774 }, { 198, 774 },
 { 199, 774 }, { 200, 774 }, { 201, 774 }, { 202, 774 }, { 203, 774 },
 { 204, 774 }, { 205, 774 }, { 206, 774 }, { 207, 774 }, { 208, 774 },
 { 209, 774 }, { 210, 774 }, { 211, 774 }, { 212, 774 }, { 213, 774 },
 { 214, 774 }, { 215, 774 }, { 216, 774 }, { 217, 774 }, { 218, 774 },
 { 219, 774 }, { 220, 774 }, { 221, 774 }, { 222, 774 }, { 223, 774 },
 { 224, 774 }, { 225, 774 }, { 226, 774 }, { 227, 774 }, { 228, 774 },
 { 229, 774 }, { 230, 774 }, { 231, 774 }, { 232, 774 }, { 233, 774 },
 { 234, 774 }, { 235, 774 }, { 236, 774 }, { 237, 774 }, { 238, 774 },

 { 239, 774 }, { 240, 774 }, { 241, 774 }, { 242, 774 }, { 243, 774 },
 { 244, 774 }, { 245, 774 }, { 246, 774 }, { 247, 774 }, { 248, 774 },
 { 249, 774 }, { 250, 774 }, { 251, 774 }, { 252, 774 }, { 253, 774 },
 { 254, 774 }, { 255, 774 }, { 256, 774 }, {   0,   1 }, {   0,5565 },
 {   1,2084 }, {   2,2084 }, {   3,2084 }, {   4,2084 }, {   5,2084 },
 {   6,2084 }, {   7,2084 }, {   8,2084 }, {   9,2084 }, {  10,1268 },
 {  11,2084 }, {  12,2084 }, {  13,1270 }, {  14,2084 }, {  15,2084 },
 {  16,2084 }, {  17,2084 }, {  18,2084 }, {  19,2084 }, {  20,2084 },
 {  21,2084 }, {  22,2084 }, {  23,2084 }, {  24,2084 }, {  25,2084 },
 {  26,2084 }, {  27,2084 }, {  28,2084 }, {  29,2084 }, {  30,2084 },

 {  31,2084 }, {  32,2084 }, {  33,2084 }, {  34,2084 }, {  35,2084 },
 {  36,2084 }, {  37,2084 }, {  38,2084 }, {  39,2084 }, {  40,2084 },
 {  41,2084 }, {  42,2084 }, {  43,2084 }, {  44,2084 }, {  45,2084 },
 {  46,2084 }, {  47,2084 }, {  48,2084 }, {  49,2084 }, {  50,2084 },
 {  51,2084 }, {  52,2084 }, {  53,2084 }, {  54,2084 }, {  55,2084 },
 {  56,2084 }, {  57,2084 }, {  58,2084 }, {  59,2084 }, {  60,2084 },
 {  61,2084 }, {  62,2084 }, {  63,2084 }, {  64,2084 }, {  65,2084 },
 {  66,2084 }, {  67,2084 }, {  68,2084 }, {  69,2084 }, {  70,2084 },
 {  71,2084 }, {  72,2084 }, {  73,2084 }, {  74,2084 }, {  75,2084 },
 {  76,2084 }, {  77,2084 }, {  78,2084 }, {  79,2084 }, {  80,2084 },

 {  81,2084 }, {  82,2084 }, {  83,2084 }, {  84,2084 }, {  85,2084 },
 {  86,2084 }, {  87,2084 }, {  88,2084 }, {  89,2084 }, {  90,2084 },
 {  91,2084 }, {  92,2084 }, {  93,2084 }, {  94,2084 }, {  95,2084 },
 {  96,2084 }, {  97,2084 }, {  98,2084 }, {  99,2084 }, { 100,2084 },
 { 101,2084 }, { 102,2084 }, { 103,2084 }, { 104,2084 }, { 105,2084 },
 { 106,2084 }, { 107,2084 }, { 108,2084 }, { 109,2084 }, { 110,2084 },
 { 111,2084 }, { 112,2084 }, { 113,2084 }, { 114,2084 }, { 115,2084 },
 { 116,2084 }, { 117,2084 }, { 118,2084 }, { 119,2084 }, { 120,2084 },
 { 121,2084 }, { 122,2084 }, { 123,2084 }, { 124,2084 }, { 125,2084 },
 { 126,2084 }, { 127,2084 }, { 128,2084 }, { 129,2084 }, { 130,2084 },

 { 131,2084 }, { 132,2084 }, { 133,2084 }, { 134,2084 }, { 135,2084 },
 { 136,2084 }, { 137,2084 }, { 138,2084 }, { 139,2084 }, { 140,2084 },
 { 141,2084 }, { 142,2084 }, { 143,2084 }, { 144,2084 }, { 145,2084 },
 { 146,2084 }, { 147,2084 }, { 148,2084 }, { 149,2084 }, { 150,2084 },
 { 151,2084 }, { 152,2084 }, { 153,2084 }, { 154,2084 }, { 155,2084 },
 { 156,2084 }, { 157,2084 }, { 158,2084 }, { 159,2084 }, { 160,2084 },
 { 161,2084 }, { 162,2084 }, { 163,2084 }, { 164,2084 }, { 165,2084 },
 { 166,2084 }, { 167,2084 }, { 168,2084 }, { 169,2084 }, { 170,2084 },
 { 171,2084 }, { 172,2084 }, { 173,2084 }, { 174,2084 }, { 175,2084 },
 { 176,2084 }, { 177,2084 }, { 178,2084 }, { 179,2084 }, { 180,2084 },

 { 181,2084 }, { 182,2084 }, { 183,2084 }, { 184,2084 }, { 185,2084 },
 { 186,2084 }, { 187,2084 }, { 188,2084 }, { 189,2084 }, { 190,2084 },
 { 191,2084 }, { 192,2084 }, { 193,2084 }, { 194,2084 }, { 195,2084 },
 { 196,2084 }, { 197,2084 }, { 198,2084 }, { 199,2084 }, { 200,2084 },
 { 201,2084 }, { 202,2084 }, { 203,2084 }, { 204,2084 }, { 205,2084 },
 { 206,2084 }, { 207,2084 }, { 208,2084 }, { 209,2084 }, { 210,2084 },
 { 211,2084 }, { 212,2084 }, { 213,2084 }, { 214,2084 }, { 215,2084 },
 { 216,2084 }, { 217,2084 }, { 218,2084 }, { 219,2084 }, { 220,2084 },
 { 221,2084 }, { 222,2084 }, { 223,2084 }, { 224,2084 }, { 225,2084 },
 { 226,2084 }, { 227,2084 }, { 228,2084 }, { 229,2084 }, { 230,2084 },

 { 231,2084 }, { 232,2084 }, { 233,2084 }, { 234,2084 }, { 235,2084 },
 { 236,2084 }, { 237,2084 }, { 238,2084 }, { 239,2084 }, { 240,2084 },
 { 241,2084 }, { 242,2084 }, { 243,2084 }, { 244,2084 }, { 245,2084 },
 { 246,2084 }, { 247,2084 }, { 248,2084 }, { 249,2084 }, { 250,2084 },
 { 251,2084 }, { 252,2084 }, { 253,2084 }, { 254,2084 }, { 255,2084 },
 { 256,2084 }, {   0,   1 }, {   0,5307 }, {   1,1826 }, {   2,1826 },
 {   3,1826 }, {   4,1826 }, {   5,1826 }, {   6,1826 }, {   7,1826 },
 {   8,1826 }, {   9,1826 }, {  10,1010 }, {  11,1826 }, {  12,1826 },
 {  13,1012 }, {  14,1826 }, {  15,1826 }, {  16,1826 }, {  17,1826 },
 {  18,1826 }, {  19,1826 }, {  20,1826 }, {  21,1826 }, {  22,1826 },

 {  23,1826 }, {  24,1826 }, {  25,1826 }, {  26,1826 }, {  27,1826 },
 {  28,1826 }, {  29,1826 }, {  30,1826 }, {  31,1826 }, {  32,1826 },
 {  33,1826 }, {  34,1826 }, {  35,1826 }, {  36,1826 }, {  37,1826 },
 {  38,1826 }, {  39,1826 }, {  40,1826 }, {  41,1826 }, {  42,1826 },
 {  43,1826 }, {  44,1826 }, {  45,1826 }, {  46,1826 }, {  47,1826 },
 {  48,1826 }, {  49,1826 }, {  50,1826 }, {  51,1826 }, {  52,1826 },
 {  53,1826 }, {  54,1826 }, {  55,1826 }, {  56,1826 }, {  57,1826 },
 {  58,1826 }, {  59,1826 }, {  60,1826 }, {  61,1826 }, {  62,1826 },
 {  63,1826 }, {  64,1826 }, {  65,1826 }, {  66,1826 }, {  67,1826 },
 {  68,1826 }, {  69,1826 }, {  70,1826 }, {  71,1826 }, {  72,1826 },

 {  73,1826 }, {  74,1826 }, {  75,1826 }, {  76,1826 }, {  77,1826 },
 {  78,1826 }, {  79,1826 }, {  80,1826 }, {  81,1826 }, {  82,1826 },
 {  83,1826 }, {  84,1826 }, {  85,1826 }, {  86,1826 }, {  87,1826 },
 {  88,1826 }, {  89,1826 }, {  90,1826 }, {  91,1826 }, {  92,1826 },
 {  93,1826 }, {  94,1826 }, {  95,1826 }, {  96,1826 }, {  97,1826 },
 {  98,1826 }, {  99,1826 }, { 100,1826 }, { 101,1826 }, { 102,1826 },
 { 103,1826 }, { 104,1826 }, { 105,1826 }, { 106,1826 }, { 107,1826 },
 { 108,1826 }, { 109,1826 }, { 110,1826 }, { 111,1826 }, { 112,1826 },
 { 113,1826 }, { 114,1826 }, { 115,1826 }, { 116,1826 }, { 117,1826 },
 { 118,1826 }, { 119,1826 }, { 120,1826 }, { 121,1826 }, { 122,1826 },

 { 123,1826 }, { 124,1826 }, { 125,1826 }, { 126,1826 }, { 127,1826 },
 { 128,1826 }, { 129,1826 }, { 130,1826 }, { 131,1826 }, { 132,1826 },
 { 133,1826 }, { 134,1826 }, { 135,1826 }, { 136,1826 }, { 137,1826 },
 { 138,1826 }, { 139,1826 }, { 140,1826 }, { 141,1826 }, { 142,1826 },
 { 143,1826 }, { 144,1826 }, { 145,1826 }, { 146,1826 }, { 147,1826 },
 { 148,1826 }, { 149,1826 }, { 150,1826 }, { 151,1826 }, { 152,1826 },
 { 153,1826 }, { 154,1826 }, { 155,1826 }, { 156,1826 }, { 157,1826 },
 { 158,1826 }, { 159,1826 }, { 160,1826 }, { 161,1826 }, { 162,1826 },
 { 163,1826 }, { 164,1826 }, { 165,1826 }, { 166,1826 }, { 167,1826 },
 { 168,1826 }, { 169,1826 }, { 170,1826 }, { 171,1826 }, { 172,1826 },

 { 173,1826 }, { 174,1826 }, { 175,1826 }, { 176,1826 }, { 177,1826 },
 { 178,1826 }, { 179,1826 }, { 180,1826 }, { 181,1826 }, { 182,1826 },
 { 183,1826 }, { 184,1826 }, { 185,1826 }, { 186,1826 }, { 187,1826 },
 { 188,1826 }, { 189,1826 }, { 190,1826 }, { 191,1826 }, { 192,1826 },
 { 193,1826 }, { 194,1826 }, { 195,1826 }, { 196,1826 }, { 197,1826 },
 { 198,1826 }, { 199,1826 }, { 200,1826 }, { 201,1826 }, { 202,1826 },
 { 203,1826 }, { 204,1826 }, { 205,1826 }, { 206,1826 }, { 207,1826 },
 { 208,1826 }, { 209,1826 }, { 210,1826 }, { 211,1826 }, { 212,1826 },
 { 213,1826 }, { 214,1826 }, { 215,1826 }, { 216,1826 }, { 217,1826 },
 { 218,1826 }, { 219,1826 }, { 220,1826 }, { 221,1826 }, { 222,1826 },

 { 223,1826 }, { 224,1826 }, { 225,1826 }, { 226,1826 }, { 227,1826 },
 { 228,1826 }, { 229,1826 }, { 230,1826 }, { 231,1826 }, { 232,1826 },
 { 233,1826 }, { 234,1826 }, { 235,1826 }, { 236,1826 }, { 237,1826 },
 { 238,1826 }, { 239,1826 }, { 240,1826 }, { 241,1826 }, { 242,1826 },
 { 243,1826 }, { 244,1826 }, { 245,1826 }, { 246,1826 }, { 247,1826 },
 { 248,1826 }, { 249,1826 }, { 250,1826 }, { 251,1826 }, { 252,1826 },
 { 253,1826 }, { 254,1826 }, { 255,1826 }, { 256,1826 }, {   0,  31 },
 {   0,5049 }, {   0,   3 }, {   0,5047 }, {   0,   2 }, {   0,5045 },
 {   0,   2 }, {   0,5043 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   9,1824 }, {   0,   0 }, {   0,   0 }, {  12,1824 },

 {   0,   0 }, {  10, 751 }, {  13, 753 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,  31 }, {   0,5017 }, {   0,   0 }, {  32,1824 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {  65,1948 }, {  66,2072 }, {  67,2072 },
 {  68,2072 }, {  69,2072 }, {  70,2072 }, {  71,2072 }, {  72,2072 },
 {  73,2072 }, {  74,2072 }, {  75,2072 }, {  76,2072 }, {  77,2072 },
 {  78,2072 }, {  79,2072 }, {  80,2072 }, {  81,2072 }, {  82,2072 },
 {  83,2072 }, {  84,2072 }, {  85,2072 }, {  86,2072 }, {  87,2072 },
 {  88,2072 }, {  89,2072 }, {  90,2072 }, {  61, 728 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  95,2072 }, {   0,   0 }, {  97,1948 },
 {  98,2072 }, {  99,2072 }, { 100,2072 }, { 101,2072 }, { 102,2072 },
 { 103,2072 }, { 104,2072 }, { 105,2072 }, { 106,2072 }, { 107,2072 },
 { 108,2072 }, { 109,2072 }, { 110,2072 }, { 111,2072 }, { 112,2072 },

 { 113,2072 }, { 114,2072 }, { 115,2072 }, { 116,2072 }, { 117,2072 },
 { 118,2072 }, { 119,2072 }, { 120,2072 }, { 121,2072 }, { 122,2072 },
 {   0,  11 }, {   0,4923 }, {   1,2072 }, {   2,2072 }, {   3,2072 },
 {   4,2072 }, {   5,2072 }, {   6,2072 }, {   7,2072 }, {   8,2072 },
 {   9,2072 }, {   0,   0 }, {  11,2072 }, {  12,2072 }, {   0,   0 },
 {  14,2072 }, {  15,2072 }, {  16,2072 }, {  17,2072 }, {  18,2072 },
 {  19,2072 }, {  20,2072 }, {  21,2072 }, {  22,2072 }, {  23,2072 },
 {  24,2072 }, {  25,2072 }, {  26,2072 }, {  27,2072 }, {  28,2072 },
 {  29,2072 }, {  30,2072 }, {  31,2072 }, {  32,2072 }, {  33,2072 },
 {  34, 636 }, {  35,2072 }, {  36,2072 }, {  37,2072 }, {  38,2072 },

 {  39,2072 }, {  40,2072 }, {  41,2072 }, {  42,2072 }, {  43,2072 },
 {  44,2072 }, {  45,2072 }, {  46,2072 }, {  47,2072 }, {  48,2072 },
 {  49,2072 }, {  50,2072 }, {  51,2072 }, {  52,2072 }, {  53,2072 },
 {  54,2072 }, {  55,2072 }, {  56,2072 }, {  57,2072 }, {  58,2072 },
 {  59,2072 }, {  60,2072 }, {  61,2072 }, {  62,2072 }, {  63,2072 },
 {  64,2072 }, {  65,2072 }, {  66,2072 }, {  67,2072 }, {  68,2072 },
 {  69,2072 }, {  70,2072 }, {  71,2072 }, {  72,2072 }, {  73,2072 },
 {  74,2072 }, {  75,2072 }, {  76,2072 }, {  77,2072 }, {  78,2072 },
 {  79,2072 }, {  80,2072 }, {  81,2072 }, {  82,2072 }, {  83,2072 },
 {  84,2072 }, {  85,2072 }, {  86,2072 }, {  87,2072 }, {  88,2072 },

 {  89,2072 }, {  90,2072 }, {  91,2072 }, {  92,2072 }, {  93,2072 },
 {  94,2072 }, {  95,2072 }, {  96,2072 }, {  97,2072 }, {  98,2072 },
 {  99,2072 }, { 100,2072 }, { 101,2072 }, { 102,2072 }, { 103,2072 },
 { 104,2072 }, { 105,2072 }, { 106,2072 }, { 107,2072 }, { 108,2072 },
 { 109,2072 }, { 110,2072 }, { 111,2072 }, { 112,2072 }, { 113,2072 },
 { 114,2072 }, { 115,2072 }, { 116,2072 }, { 117,2072 }, { 118,2072 },
 { 119,2072 }, { 120,2072 }, { 121,2072 }, { 122,2072 }, { 123,2072 },
 { 124,2072 }, { 125,2072 }, { 126,2072 }, { 127,2072 }, { 128,2072 },
 { 129,2072 }, { 130,2072 }, { 131,2072 }, { 132,2072 }, { 133,2072 },
 { 134,2072 }, { 135,2072 }, { 136,2072 }, { 137,2072 }, { 138,2072 },

 { 139,2072 }, { 140,2072 }, { 141,2072 }, { 142,2072 }, { 143,2072 },
 { 144,2072 }, { 145,2072 }, { 146,2072 }, { 147,2072 }, { 148,2072 },
 { 149,2072 }, { 150,2072 }, { 151,2072 }, { 152,2072 }, { 153,2072 },
 { 154,2072 }, { 155,2072 }, { 156,2072 }, { 157,2072 }, { 158,2072 },
 { 159,2072 }, { 160,2072 }, { 161,2072 }, { 162,2072 }, { 163,2072 },
 { 164,2072 }, { 165,2072 }, { 166,2072 }, { 167,2072 }, { 168,2072 },
 { 169,2072 }, { 170,2072 }, { 171,2072 }, { 172,2072 }, { 173,2072 },
 { 174,2072 }, { 175,2072 }, { 176,2072 }, { 177,2072 }, { 178,2072 },
 { 179,2072 }, { 180,2072 }, { 181,2072 }, { 182,2072 }, { 183,2072 },
 { 184,2072 }, { 185,2072 }, { 186,2072 }, { 187,2072 }, { 188,2072 },

 { 189,2072 }, { 190,2072 }, { 191,2072 }, { 192,2072 }, { 193,2072 },
 { 194,2072 }, { 195,2072 }, { 196,2072 }, { 197,2072 }, { 198,2072 },
 { 199,2072 }, { 200,2072 }, { 201,2072 }, { 202,2072 }, { 203,2072 },
 { 204,2072 }, { 205,2072 }, { 206,2072 }, { 207,2072 }, { 208,2072 },
 { 209,2072 }, { 210,2072 }, { 211,2072 }, { 212,2072 }, { 213,2072 },
 { 214,2072 }, { 215,2072 }, { 216,2072 }, { 217,2072 }, { 218,2072 },
 { 219,2072 }, { 220,2072 }, { 221,2072 }, { 222,2072 }, { 223,2072 },
 { 224,2072 }, { 225,2072 }, { 226,2072 }, { 227,2072 }, { 228,2072 },
 { 229,2072 }, { 230,2072 }, { 231,2072 }, { 232,2072 }, { 233,2072 },
 { 234,2072 }, { 235,2072 }, { 236,2072 }, { 237,2072 }, { 238,2072 },

 { 239,2072 }, { 240,2072 }, { 241,2072 }, { 242,2072 }, { 243,2072 },
 { 244,2072 }, { 245,2072 }, { 246,2072 }, { 247,2072 }, { 248,2072 },
 { 249,2072 }, { 250,2072 }, { 251,2072 }, { 252,2072 }, { 253,2072 },
 { 254,2072 }, { 255,2072 }, { 256,2072 }, {   0,  31 }, {   0,4665 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,  31 }, {   0,4641 }, {   0,  31 },
 {   0,4639 }, {   0,   0 }, {   0,  31 }, {   0,4636 }, {   0,  31 },

 {   0,4634 }, {   0,  31 }, {   0,4632 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  48,2072 }, {  49,2072 }, {  50,2072 },
 {  51,2072 }, {  52,2072 }, {  53,2072 }, {  54,2072 }, {  55,2072 },
 {  56,2072 }, {  57,2072 }, {  34, 432 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  39, 469 }, {  38, 471 }, {  65,2072 },
 {  66,2072 }, {  67,2072 }, {  68,2072 }, {  69,2072 }, {  70,2072 },
 {  42, 486 }, {  48, 471 }, {  49, 471 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  60, 499 }, {  61, 501 }, {  62, 503 }, {  61, 503 }, {   0,   0 },
 {   0,   0 }, {  97,2072 }, {  98,2072 }, {  99,2072 }, { 100,2072 },
 { 101,2072 }, { 102,2072 }, {   0,  10 }, {   0,4561 }, {   1,2072 },
 {   2,2072 }, {   3,2072 }, {   4,2072 }, {   5,2072 }, {   6,2072 },
 {   7,2072 }, {   8,2072 }, {   9,2072 }, {   0,   0 }, {  11,2072 },
 {  12,2072 }, {   0,   0 }, {  14,2072 }, {  15,2072 }, {  16,2072 },
 {  17,2072 }, {  18,2072 }, {  19,2072 }, {  20,2072 }, {  21,2072 },
 {  22,2072 }, {  23,2072 }, {  24,2072 }, {  25,2072 }, {  26,2072 },

 {  27,2072 }, {  28,2072 }, {  29,2072 }, {  30,2072 }, {  31,2072 },
 {  32,2072 }, {  33,2072 }, {  34,2072 }, {  35,2072 }, {  36,2072 },
 {  37,2072 }, {  38,2072 }, {  39, 395 }, {  40,2072 }, {  41,2072 },
 {  42,2072 }, {  43,2072 }, {  44,2072 }, {  45,2072 }, {  46,2072 },
 {  47,2072 }, {  48,2072 }, {  49,2072 }, {  50,2072 }, {  51,2072 },
 {  52,2072 }, {  53,2072 }, {  54,2072 }, {  55,2072 }, {  56,2072 },
 {  57,2072 }, {  58,2072 }, {  59,2072 }, {  60,2072 }, {  61,2072 },
 {  62,2072 }, {  63,2072 }, {  64,2072 }, {  65,2072 }, {  66,2072 },
 {  67,2072 }, {  68,2072 }, {  69,2072 }, {  70,2072 }, {  71,2072 },
 {  72,2072 }, {  73,2072 }, {  74,2072 }, {  75,2072 }, {  76,2072 },

 {  77,2072 }, {  78,2072 }, {  79,2072 }, {  80,2072 }, {  81,2072 },
 {  82,2072 }, {  83,2072 }, {  84,2072 }, {  85,2072 }, {  86,2072 },
 {  87,2072 }, {  88,2072 }, {  89,2072 }, {  90,2072 }, {  91,2072 },
 {  92,2072 }, {  93,2072 }, {  94,2072 }, {  95,2072 }, {  96,2072 },
 {  97,2072 }, {  98,2072 }, {  99,2072 }, { 100,2072 }, { 101,2072 },
 { 102,2072 }, { 103,2072 }, { 104,2072 }, { 105,2072 }, { 106,2072 },
 { 107,2072 }, { 108,2072 }, { 109,2072 }, { 110,2072 }, { 111,2072 },
 { 112,2072 }, { 113,2072 }, { 114,2072 }, { 115,2072 }, { 116,2072 },
 { 117,2072 }, { 118,2072 }, { 119,2072 }, { 120,2072 }, { 121,2072 },
 { 122,2072 }, { 123,2072 }, { 124,2072 }, { 125,2072 }, { 126,2072 },

 { 127,2072 }, { 128,2072 }, { 129,2072 }, { 130,2072 }, { 131,2072 },
 { 132,2072 }, { 133,2072 }, { 134,2072 }, { 135,2072 }, { 136,2072 },
 { 137,2072 }, { 138,2072 }, { 139,2072 }, { 140,2072 }, { 141,2072 },
 { 142,2072 }, { 143,2072 }, { 144,2072 }, { 145,2072 }, { 146,2072 },
 { 147,2072 }, { 148,2072 }, { 149,2072 }, { 150,2072 }, { 151,2072 },
 { 152,2072 }, { 153,2072 }, { 154,2072 }, { 155,2072 }, { 156,2072 },
 { 157,2072 }, { 158,2072 }, { 159,2072 }, { 160,2072 }, { 161,2072 },
 { 162,2072 }, { 163,2072 }, { 164,2072 }, { 165,2072 }, { 166,2072 },
 { 167,2072 }, { 168,2072 }, { 169,2072 }, { 170,2072 }, { 171,2072 },
 { 172,2072 }, { 173,2072 }, { 174,2072 }, { 175,2072 }, { 176,2072 },

 { 177,2072 }, { 178,2072 }, { 179,2072 }, { 180,2072 }, { 181,2072 },
 { 182,2072 }, { 183,2072 }, { 184,2072 }, { 185,2072 }, { 186,2072 },
 { 187,2072 }, { 188,2072 }, { 189,2072 }, { 190,2072 }, { 191,2072 },
 { 192,2072 }, { 193,2072 }, { 194,2072 }, { 195,2072 }, { 196,2072 },
 { 197,2072 }, { 198,2072 }, { 199,2072 }, { 200,2072 }, { 201,2072 },
 { 202,2072 }, { 203,2072 }, { 204,2072 }, { 205,2072 }, { 206,2072 },
 { 207,2072 }, { 208,2072 }, { 209,2072 }, { 210,2072 }, { 211,2072 },
 { 212,2072 }, { 213,2072 }, { 214,2072 }, { 215,2072 }, { 216,2072 },
 { 217,2072 }, { 218,2072 }, { 219,2072 }, { 220,2072 }, { 221,2072 },
 { 222,2072 }, { 223,2072 }, { 224,2072 }, { 225,2072 }, { 226,2072 },

 { 227,2072 }, { 228,2072 }, { 229,2072 }, { 230,2072 }, { 231,2072 },
 { 232,2072 }, { 233,2072 }, { 234,2072 }, { 235,2072 }, { 236,2072 },
 { 237,2072 }, { 238,2072 }, { 239,2072 }, { 240,2072 }, { 241,2072 },
 { 242,2072 }, { 243,2072 }, { 244,2072 }, { 245,2072 }, { 246,2072 },
 { 247,2072 }, { 248,2072 }, { 249,2072 }, { 250,2072 }, { 251,2072 },
 { 252,2072 }, { 253,2072 }, { 254,2072 }, { 255,2072 }, { 256,2072 },
 {   0,  31 }, {   0,4303 }, {   0,  31 }, {   0,4301 }, {   0,  31 },
 {   0,4299 }, {   0,   1 }, {   0,4297 }, {   0,   1 }, {   0,4295 },
 {   9,2072 }, {   0,   2 }, {   0,4292 }, {  12,2072 }, {   0,  23 },
 {   0,4289 }, {   0,   9 }, {   0,4287 }, {   0,   0 }, {  10, 227 },

 {  13, 229 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,2072 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  61, 176 },
 {  62, 182 }, {  65,2196 }, {  66,2320 }, {  67,2320 }, {  68,2320 },

 {  69,2320 }, {  70,2320 }, {  71,2320 }, {  72,2320 }, {  73,2320 },
 {  74,2320 }, {  75,2320 }, {  76,2320 }, {  77,2320 }, {  78,2320 },
 {  79,2320 }, {  80,2320 }, {  81,2320 }, {  82,2320 }, {  83,2320 },
 {  84,2320 }, {  85,2320 }, {  86,2320 }, {  87,2320 }, {  88,2320 },
 {  89,2320 }, {  90,2320 }, {   0,  12 }, {   0,4211 }, {   0,   0 },
 {   0,4209 }, {  95,2320 }, {   0,   0 }, {  97,2196 }, {  98,2320 },
 {  99,2320 }, { 100,2320 }, { 101,2320 }, { 102,2320 }, { 103,2320 },
 { 104,2320 }, { 105,2320 }, { 106,2320 }, { 107,2320 }, { 108,2320 },
 { 109,2320 }, { 110,2320 }, { 111,2320 }, { 112,2320 }, { 113,2320 },
 { 114,2320 }, { 115,2320 }, { 116,2320 }, { 117,2320 }, { 118,2320 },

 { 119,2320 }, { 120,2320 }, { 121,2320 }, { 122,2320 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, { 124, 225 },
 {  35, 163 }, {   0,   0 }, {   0,4172 }, {   0,  17 }, {   0,4170 },
 {   0,  27 }, {   0,4168 }, {   0,   8 }, {   0,4166 }, {   0,   0 },
 {  45, 163 }, {  48,2320 }, {  49,2320 }, {  50,2379 }, {  51,2379 },
 {  52,2379 }, {  53,2379 }, {  54,2379 }, {  55,2379 }, {  56,2379 },
 {  57,2379 }, {   0,  12 }, {   0,4152 }, {   0,  30 }, {   0,4150 },
 {   0,  13 }, {   0,4148 }, {   0,   0 }, {  65,2438 }, {  66,2497 },
 {  67,2438 }, {  68,2438 }, {  69,2438 }, {  70,2438 }, {   0,   0 },
 {  72,  63 }, {   0,   0 }, {  35, 445 }, {   0,  28 }, {   0,4135 },

 {   0,  24 }, {   0,4133 }, {   0,  22 }, {   0,4131 }, {   0,  21 },
 {   0,4129 }, {   0,   0 }, {  45, 445 }, {   0,  25 }, {   0,4125 },
 {   0,   0 }, {  88,2522 }, {  48,   0 }, {  49,   0 }, {   0,  29 },
 {   0,4119 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  97,2438 }, {  98,2497 }, {  99,2438 }, { 100,2438 }, { 101,2438 },
 { 102,2438 }, {   0,   0 }, { 104,  63 }, {   0,   0 }, {   0,   0 },
 {  48,2261 }, {  49,2261 }, {  50,2320 }, {  51,2320 }, {  52,2320 },
 {  53,2320 }, {  54,2320 }, {  55,2320 }, {  56,2320 }, {  57,2320 },
 {   0,  12 }, {   0,4093 }, {   0,   0 }, { 120,2522 }, {   0,   0 },
 {   0,   0 }, {   0,4088 }, {  65,2379 }, {  66,2501 }, {  67,2379 },

 {  68,2379 }, {  69,2379 }, {  70,2379 }, {   0,   0 }, {  72,   4 },
 {   9,   0 }, {   0,   7 }, {   0,4077 }, {  12,   0 }, {   0,  26 },
 {   0,4074 }, {   0,   1 }, {   0,4072 }, {   0,   1 }, {   0,4070 },
 {   0,   1 }, {   0,4068 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  10,   2 },
 {  13,   4 }, {   0,   0 }, {   0,   0 }, {  32,   0 }, {  97,2379 },
 {  98,2501 }, {  99,2379 }, { 100,2379 }, { 101,2379 }, { 102,2379 },
 {   0,   0 }, { 104,   4 }, {   0,   0 }, {   0,4046 }, {  48,2261 },
 {  49,2261 }, {  50,2261 }, {  51,2261 }, {  52,2261 }, {  53,2261 },
 {  54,2261 }, {  55,2261 }, {  56,2261 }, {  57,2261 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  58,  11 },
 {   0,   0 }, {  65,2320 }, {  66,2320 }, {  67,2320 }, {  68,2320 },
 {  69,2320 }, {  70,2320 }, {   0,   0 }, {  72, -55 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  34, 447 }, {  35,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  45,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  97,2320 }, {  98,2320 },
 {  99,2320 }, { 100,2320 }, { 101,2320 }, { 102,2320 }, {   0,   0 },
 { 104, -55 }, {   0,   4 }, {   0,3987 }, {   1,2442 }, {   2,2442 },

 {   3,2442 }, {   4,2442 }, {   5,2442 }, {   6,2442 }, {   7,2442 },
 {   8,2442 }, {   9,2442 }, {   0,   0 }, {  11,2442 }, {  12,2442 },
 {  13,2442 }, {  14,2442 }, {  15,2442 }, {  16,2442 }, {  17,2442 },
 {  18,2442 }, {  19,2442 }, {  20,2442 }, {  21,2442 }, {  22,2442 },
 {  23,2442 }, {  24,2442 }, {  25,2442 }, {  26,2442 }, {  27,2442 },
 {  28,2442 }, {  29,2442 }, {  30,2442 }, {  31,2442 }, {  32,2442 },
 {  33,2442 }, {  34,2442 }, {  35,2442 }, {  36,2442 }, {  37,2442 },
 {  38,2442 }, {  39,2442 }, {  40,2442 }, {  41,2442 }, {  42,2442 },
 {  43,2442 }, {  44,2442 }, {  45,2442 }, {  46,2442 }, {  47,2442 },
 {  48,2442 }, {  49,2442 }, {  50,2442 }, {  51,2442 }, {  52,2442 },

 {  53,2442 }, {  54,2442 }, {  55,2442 }, {  56,2442 }, {  57,2442 },
 {  58,2442 }, {  59,2442 }, {  60,2442 }, {  61,2442 }, {  62,2442 },
 {  63,2442 }, {  64,2442 }, {  65,2442 }, {  66,2442 }, {  67,2442 },
 {  68,2442 }, {  69,2442 }, {  70,2442 }, {  71,2442 }, {  72,2442 },
 {  73,2442 }, {  74,2442 }, {  75,2442 }, {  76,2442 }, {  77,2442 },
 {  78,2442 }, {  79,2442 }, {  80,2442 }, {  81,2442 }, {  82,2442 },
 {  83,2442 }, {  84,2442 }, {  85,2442 }, {  86,2442 }, {  87,2442 },
 {  88,2442 }, {  89,2442 }, {  90,2442 }, {  91,2442 }, {  92,2442 },
 {  93,2442 }, {  94,2442 }, {  95,2442 }, {  96,2442 }, {  97,2442 },
 {  98,2442 }, {  99,2442 }, { 100,2442 }, { 101,2442 }, { 102,2442 },

 { 103,2442 }, { 104,2442 }, { 105,2442 }, { 106,2442 }, { 107,2442 },
 { 108,2442 }, { 109,2442 }, { 110,2442 }, { 111,2442 }, { 112,2442 },
 { 113,2442 }, { 114,2442 }, { 115,2442 }, { 116,2442 }, { 117,2442 },
 { 118,2442 }, { 119,2442 }, { 120,2442 }, { 121,2442 }, { 122,2442 },
 { 123,2442 }, { 124,2442 }, { 125,2442 }, { 126,2442 }, { 127,2442 },
 { 128,2442 }, { 129,2442 }, { 130,2442 }, { 131,2442 }, { 132,2442 },
 { 133,2442 }, { 134,2442 }, { 135,2442 }, { 136,2442 }, { 137,2442 },
 { 138,2442 }, { 139,2442 }, { 140,2442 }, { 141,2442 }, { 142,2442 },
 { 143,2442 }, { 144,2442 }, { 145,2442 }, { 146,2442 }, { 147,2442 },
 { 148,2442 }, { 149,2442 }, { 150,2442 }, { 151,2442 }, { 152,2442 },

 { 153,2442 }, { 154,2442 }, { 155,2442 }, { 156,2442 }, { 157,2442 },
 { 158,2442 }, { 159,2442 }, { 160,2442 }, { 161,2442 }, { 162,2442 },
 { 163,2442 }, { 164,2442 }, { 165,2442 }, { 166,2442 }, { 167,2442 },
 { 168,2442 }, { 169,2442 }, { 170,2442 }, { 171,2442 }, { 172,2442 },
 { 173,2442 }, { 174,2442 }, { 175,2442 }, { 176,2442 }, { 177,2442 },
 { 178,2442 }, { 179,2442 }, { 180,2442 }, { 181,2442 }, { 182,2442 },
 { 183,2442 }, { 184,2442 }, { 185,2442 }, { 186,2442 }, { 187,2442 },
 { 188,2442 }, { 189,2442 }, { 190,2442 }, { 191,2442 }, { 192,2442 },
 { 193,2442 }, { 194,2442 }, { 195,2442 }, { 196,2442 }, { 197,2442 },
 { 198,2442 }, { 199,2442 }, { 200,2442 }, { 201,2442 }, { 202,2442 },

 { 203,2442 }, { 204,2442 }, { 205,2442 }, { 206,2442 }, { 207,2442 },
 { 208,2442 }, { 209,2442 }, { 210,2442 }, { 211,2442 }, { 212,2442 },
 { 213,2442 }, { 214,2442 }, { 215,2442 }, { 216,2442 }, { 217,2442 },
 { 218,2442 }, { 219,2442 }, { 220,2442 }, { 221,2442 }, { 222,2442 },
 { 223,2442 }, { 224,2442 }, { 225,2442 }, { 226,2442 }, { 227,2442 },
 { 228,2442 }, { 229,2442 }, { 230,2442 }, { 231,2442 }, { 232,2442 },
 { 233,2442 }, { 234,2442 }, { 235,2442 }, { 236,2442 }, { 237,2442 },
 { 238,2442 }, { 239,2442 }, { 240,2442 }, { 241,2442 }, { 242,2442 },
 { 243,2442 }, { 244,2442 }, { 245,2442 }, { 246,2442 }, { 247,2442 },
 { 248,2442 }, { 249,2442 }, { 250,2442 }, { 251,2442 }, { 252,2442 },

 { 253,2442 }, { 254,2442 }, { 255,2442 }, { 256,2442 }, {   0,   5 },
 {   0,3729 }, {   0,   0 }, {   0,3727 }, {   0,   6 }, {   0,3725 },
 {   0,   6 }, {   0,3723 }, {   0,   0 }, {   0,   0 }, {   9,-359 },
 {   0,   0 }, {   0,   0 }, {  12,-359 }, {   9,   0 }, {   0,   0 },
 {   0,   0 }, {  12,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  32,-359 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  32,   0 }, {  35,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  39, 130 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {  45,   0 }, {  48,2442 }, {  49,2442 },
 {  50,2442 }, {  51,2442 }, {  52,2442 }, {  53,2442 }, {  54,2442 },
 {  55,2442 }, {  56,2442 }, {  57,2442 }, {  58,-348 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  58,   2 }, {   0,   0 }, {   0,   0 },
 {  65,2442 }, {  66,2442 }, {  67,2442 }, {  68,2442 }, {  69,2442 },
 {  70,2566 }, {  71,2442 }, {  72,2442 }, {  73,2442 }, {  74,2442 },
 {  75,2442 }, {  76,2442 }, {  77,2442 }, {  78,2442 }, {  79,2442 },
 {  80,2442 }, {  81,2442 }, {  82,2442 }, {  83,2442 }, {  84,2442 },
 {  85,2442 }, {  86,2442 }, {  87,2442 }, {  88,2442 }, {  89,2442 },
 {  90,2442 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {  95,2442 }, {   0,   0 }, {  97,2442 }, {  98,2442 }, {  99,2442 },
 { 100,2442 }, { 101,2442 }, { 102,2566 }, { 103,2442 }, { 104,2442 },
 { 105,2442 }, { 106,2442 }, { 107,2442 }, { 108,2442 }, { 109,2442 },
 { 110,2442 }, { 111,2442 }, { 112,2442 }, { 113,2442 }, { 114,2442 },
 { 115,2442 }, { 116,2442 }, { 117,2442 }, { 118,2442 }, { 119,2442 },
 { 120,2442 }, { 121,2442 }, { 122,2442 }, {   0,   5 }, {   0,3605 },
 {   0,   5 }, {   0,3603 }, {   0,   0 }, {   0,3601 }, {   0,  20 },
 {   0,3599 }, {   0,  19 }, {   0,3597 }, {   9,-483 }, {   0,   0 },
 {   9,-485 }, {  12,-483 }, {   9,-487 }, {  12,-485 }, {   0,   0 },
 {  12,-487 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  32,-483 }, {   0,   0 }, {  32,-485 }, {   0,   0 },
 {  32,-487 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  48,2318 }, {  49,2318 }, {  50,2318 },
 {  51,2318 }, {  52,2318 }, {  53,2318 }, {  54,2318 }, {  55,2318 },
 {  56,2318 }, {  57,2318 }, {  58,-472 }, {   0,   0 }, {  58,-474 },
 {   0,   0 }, {  58,-476 }, {   0,   0 }, {   0,   0 }, {  65,2318 },
 {  66,2318 }, {  67,2318 }, {  68,2318 }, {  69,2318 }, {  70,2318 },

 {  71,2318 }, {  72,2318 }, {  73,2318 }, {  74,2318 }, {  75,2318 },
 {  76,2318 }, {  77,2318 }, {  78,2318 }, {  79,2318 }, {  80,2318 },
 {  81,2318 }, {  82,2318 }, {  83,2318 }, {  84,2318 }, {  85,2318 },
 {  86,2318 }, {  87,2318 }, {  88,2318 }, {  89,2318 }, {  90,2318 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  95,2318 },
 {   0,   0 }, {  97,2318 }, {  98,2318 }, {  99,2318 }, { 100,2318 },
 { 101,2318 }, { 102,2318 }, { 103,2318 }, { 104,2318 }, { 105,2318 },
 { 106,2318 }, { 107,2318 }, { 108,2318 }, { 109,2318 }, { 110,2318 },
 { 111,2318 }, { 112,2318 }, { 113,2318 }, { 114,2318 }, { 115,2318 },
 { 116,2318 }, { 117,2318 }, { 118,2318 }, { 119,2318 }, { 120,2318 },

 { 121,2318 }, { 122,2318 }, {   0,   1 }, {   0,3481 }, {   1,2442 },
 {   2,2442 }, {   3,2442 }, {   4,2442 }, {   5,2442 }, {   6,2442 },
 {   7,2442 }, {   8,2442 }, {   9,2442 }, {  10,-591 }, {  11,2442 },
 {  12,2442 }, {  13,-589 }, {  14,2442 }, {  15,2442 }, {  16,2442 },
 {  17,2442 }, {  18,2442 }, {  19,2442 }, {  20,2442 }, {  21,2442 },
 {  22,2442 }, {  23,2442 }, {  24,2442 }, {  25,2442 }, {  26,2442 },
 {  27,2442 }, {  28,2442 }, {  29,2442 }, {  30,2442 }, {  31,2442 },
 {  32,2442 }, {  33,2442 }, {  34,2442 }, {  35,2442 }, {  36,2442 },
 {  37,2442 }, {  38,2442 }, {  39,2442 }, {  40,2442 }, {  41,2442 },
 {  42,2442 }, {  43,2442 }, {  44,2442 }, {  45,2442 }, {  46,2442 },

 {  47,2442 }, {  48,2442 }, {  49,2442 }, {  50,2442 }, {  51,2442 },
 {  52,2442 }, {  53,2442 }, {  54,2442 }, {  55,2442 }, {  56,2442 },
 {  57,2442 }, {  58,2442 }, {  59,2442 }, {  60,2442 }, {  61,2442 },
 {  62,2442 }, {  63,2442 }, {  64,2442 }, {  65,2442 }, {  66,2442 },
 {  67,2442 }, {  68,2442 }, {  69,2442 }, {  70,2442 }, {  71,2442 },
 {  72,2442 }, {  73,2442 }, {  74,2442 }, {  75,2442 }, {  76,2442 },
 {  77,2442 }, {  78,2442 }, {  79,2442 }, {  80,2442 }, {  81,2442 },
 {  82,2442 }, {  83,2442 }, {  84,2442 }, {  85,2442 }, {  86,2442 },
 {  87,2442 }, {  88,2442 }, {  89,2442 }, {  90,2442 }, {  91,2442 },
 {  92,2442 }, {  93,2442 }, {  94,2442 }, {  95,2442 }, {  96,2442 },

 {  97,2442 }, {  98,2442 }, {  99,2442 }, { 100,2442 }, { 101,2442 },
 { 102,2442 }, { 103,2442 }, { 104,2442 }, { 105,2442 }, { 106,2442 },
 { 107,2442 }, { 108,2442 }, { 109,2442 }, { 110,2442 }, { 111,2442 },
 { 112,2442 }, { 113,2442 }, { 114,2442 }, { 115,2442 }, { 116,2442 },
 { 117,2442 }, { 118,2442 }, { 119,2442 }, { 120,2442 }, { 121,2442 },
 { 122,2442 }, { 123,2442 }, { 124,2442 }, { 125,2442 }, { 126,2442 },
 { 127,2442 }, { 128,2442 }, { 129,2442 }, { 130,2442 }, { 131,2442 },
 { 132,2442 }, { 133,2442 }, { 134,2442 }, { 135,2442 }, { 136,2442 },
 { 137,2442 }, { 138,2442 }, { 139,2442 }, { 140,2442 }, { 141,2442 },
 { 142,2442 }, { 143,2442 }, { 144,2442 }, { 145,2442 }, { 146,2442 },

 { 147,2442 }, { 148,2442 }, { 149,2442 }, { 150,2442 }, { 151,2442 },
 { 152,2442 }, { 153,2442 }, { 154,2442 }, { 155,2442 }, { 156,2442 },
 { 157,2442 }, { 158,2442 }, { 159,2442 }, { 160,2442 }, { 161,2442 },
 { 162,2442 }, { 163,2442 }, { 164,2442 }, { 165,2442 }, { 166,2442 },
 { 167,2442 }, { 168,2442 }, { 169,2442 }, { 170,2442 }, { 171,2442 },
 { 172,2442 }, { 173,2442 }, { 174,2442 }, { 175,2442 }, { 176,2442 },
 { 177,2442 }, { 178,2442 }, { 179,2442 }, { 180,2442 }, { 181,2442 },
 { 182,2442 }, { 183,2442 }, { 184,2442 }, { 185,2442 }, { 186,2442 },
 { 187,2442 }, { 188,2442 }, { 189,2442 }, { 190,2442 }, { 191,2442 },
 { 192,2442 }, { 193,2442 }, { 194,2442 }, { 195,2442 }, { 196,2442 },

 { 197,2442 }, { 198,2442 }, { 199,2442 }, { 200,2442 }, { 201,2442 },
 { 202,2442 }, { 203,2442 }, { 204,2442 }, { 205,2442 }, { 206,2442 },
 { 207,2442 }, { 208,2442 }, { 209,2442 }, { 210,2442 }, { 211,2442 },
 { 212,2442 }, { 213,2442 }, { 214,2442 }, { 215,2442 }, { 216,2442 },
 { 217,2442 }, { 218,2442 }, { 219,2442 }, { 220,2442 }, { 221,2442 },
 { 222,2442 }, { 223,2442 }, { 224,2442 }, { 225,2442 }, { 226,2442 },
 { 227,2442 }, { 228,2442 }, { 229,2442 }, { 230,2442 }, { 231,2442 },
 { 232,2442 }, { 233,2442 }, { 234,2442 }, { 235,2442 }, { 236,2442 },
 { 237,2442 }, { 238,2442 }, { 239,2442 }, { 240,2442 }, { 241,2442 },
 { 242,2442 }, { 243,2442 }, { 244,2442 }, { 245,2442 }, { 246,2442 },

 { 247,2442 }, { 248,2442 }, { 249,2442 }, { 250,2442 }, { 251,2442 },
 { 252,2442 }, { 253,2442 }, { 254,2442 }, { 255,2442 }, { 256,2442 },
 {   0,   3 }, {   0,3223 }, {   0,   6 }, {   0,3221 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   9,   0 }, {   0,   0 }, {   9,-504 }, {  12,   0 }, {   0,   0 },
 {  12,-504 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,   0 }, {   0,   0 },
 {  32,-504 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  58,-502 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  65, 124 }, {  66, 248 }, {  67, 248 }, {  68, 248 },
 {  69, 248 }, {  70, 248 }, {  71, 248 }, {  72, 248 }, {  73, 248 },
 {  74, 248 }, {  75, 248 }, {  76, 248 }, {  77, 248 }, {  78, 248 },
 {  79, 248 }, {  80, 248 }, {  81, 248 }, {  82, 248 }, {  83, 248 },
 {  84, 248 }, {  85, 248 }, {  86, 248 }, {  87, 248 }, {  88, 248 },

 {  89, 248 }, {  90, 248 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  95, 248 }, {   0,   0 }, {  97, 124 }, {  98, 248 },
 {  99, 248 }, { 100, 248 }, { 101, 248 }, { 102, 248 }, { 103, 248 },
 { 104, 248 }, { 105, 248 }, { 106, 248 }, { 107, 248 }, { 108, 248 },
 { 109, 248 }, { 110, 248 }, { 111, 248 }, { 112, 248 }, { 113, 248 },
 { 114, 248 }, { 115, 248 }, { 116, 248 }, { 117, 248 }, { 118, 248 },
 { 119, 248 }, { 120, 248 }, { 121, 248 }, { 122, 248 }, {   0,   0 },
 {   0,3099 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   9,-989 },
 {   0,   0 }, {   0,   0 }, {  12,-989 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  32,-989 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  48,2318 }, {  49,2318 },
 {  50,2318 }, {  51,2318 }, {  52,2318 }, {  53,2318 }, {  54,2318 },
 {  55,2318 }, {  56,2318 }, {  57,2318 }, {  58,-978 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {  65,2318 }, {  66,2318 }, {  67,2318 }, {  68,2318 }, {  69,2318 },
 {  70,2442 }, {  71,2318 }, {  72,2318 }, {  73,2318 }, {  74,2318 },
 {  75,2318 }, {  76,2318 }, {  77,2318 }, {  78,2318 }, {  79,2318 },
 {  80,2318 }, {  81,2318 }, {  82,2318 }, {  83,2318 }, {  84,2318 },
 {  85,2318 }, {  86,2318 }, {  87,2318 }, {  88,2318 }, {  89,2318 },
 {  90,2318 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  95,2318 }, {   0,   0 }, {  97,2318 }, {  98,2318 }, {  99,2318 },
 { 100,2318 }, { 101,2318 }, { 102,2442 }, { 103,2318 }, { 104,2318 },
 { 105,2318 }, { 106,2318 }, { 107,2318 }, { 108,2318 }, { 109,2318 },
 { 110,2318 }, { 111,2318 }, { 112,2318 }, { 113,2318 }, { 114,2318 },

 { 115,2318 }, { 116,2318 }, { 117,2318 }, { 118,2318 }, { 119,2318 },
 { 120,2318 }, { 121,2318 }, { 122,2318 }, {   0,   0 }, {   0,2975 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   9,-1113 }, {   0,   0 },
 {   0,   0 }, {  12,-1113 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  32,-1113 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  48,2194 }, {  49,2194 }, {  50,2194 },
 {  51,2194 }, {  52,2194 }, {  53,2194 }, {  54,2194 }, {  55,2194 },
 {  56,2194 }, {  57,2194 }, {  58,-1102 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  65,2194 },
 {  66,2194 }, {  67,2194 }, {  68,2194 }, {  69,2194 }, {  70,2194 },
 {  71,2194 }, {  72,2194 }, {  73,2194 }, {  74,2194 }, {  75,2194 },
 {  76,2194 }, {  77,2194 }, {  78,2194 }, {  79,2194 }, {  80,2194 },
 {  81,2194 }, {  82,2194 }, {  83,2194 }, {  84,2194 }, {  85,2194 },
 {  86,2194 }, {  87,2194 }, {  88,2194 }, {  89,2194 }, {  90,2194 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  95,2194 },
 {   0,   0 }, {  97,2194 }, {  98,2194 }, {  99,2194 }, { 100,2194 },
 { 101,2194 }, { 102,2194 }, { 103,2194 }, { 104,2194 }, { 105,2194 },
 { 106,2194 }, { 107,2194 }, { 108,2194 }, { 109,2194 }, { 110,2194 },
 { 111,2194 }, { 112,2194 }, { 113,2194 }, { 114,2194 }, { 115,2194 },
 { 116,2194 }, { 117,2194 }, { 118,2194 }, { 119,2194 }, { 120,2194 },
 { 121,2194 }, { 122,2194 }, {   0,  11 }, {   0,2851 }, {   1,   0 },
 {   2,   0 }, {   3,   0 }, {   4,   0 }, {   5,   0 }, {   6,   0 },
 {   7,   0 }, {   8,   0 }, {   9,   0 }, {   0,   0 }, {  11,   0 },
 {  12,   0 }, {   0,   0 }, {  14,   0 }, {  15,   0 }, {  16,   0 },

 {  17,   0 }, {  18,   0 }, {  19,   0 }, {  20,   0 }, {  21,   0 },
 {  22,   0 }, {  23,   0 }, {  24,   0 }, {  25,   0 }, {  26,   0 },
 {  27,   0 }, {  28,   0 }, {  29,   0 }, {  30,   0 }, {  31,   0 },
 {  32,   0 }, {  33,   0 }, {  34,-1436 }, {  35,   0 }, {  36,   0 },
 {  37,   0 }, {  38,   0 }, {  39,   0 }, {  40,   0 }, {  41,   0 },
 {  42,   0 }, {  43,   0 }, {  44,   0 }, {  45,   0 }, {  46,   0 },
 {  47,   0 }, {  48,   0 }, {  49,   0 }, {  50,   0 }, {  51,   0 },
 {  52,   0 }, {  53,   0 }, {  54,   0 }, {  55,   0 }, {  56,   0 },
 {  57,   0 }, {  58,   0 }, {  59,   0 }, {  60,   0 }, {  61,   0 },
 {  62,   0 }, {  63,   0 }, {  64,   0 }, {  65,   0 }, {  66,   0 },

 {  67,   0 }, {  68,   0 }, {  69,   0 }, {  70,   0 }, {  71,   0 },
 {  72,   0 }, {  73,   0 }, {  74,   0 }, {  75,   0 }, {  76,   0 },
 {  77,   0 }, {  78,   0 }, {  79,   0 }, {  80,   0 }, {  81,   0 },
 {  82,   0 }, {  83,   0 }, {  84,   0 }, {  85,   0 }, {  86,   0 },
 {  87,   0 }, {  88,   0 }, {  89,   0 }, {  90,   0 }, {  91,   0 },
 {  92,   0 }, {  93,   0 }, {  94,   0 }, {  95,   0 }, {  96,   0 },
 {  97,   0 }, {  98,   0 }, {  99,   0 }, { 100,   0 }, { 101,   0 },
 { 102,   0 }, { 103,   0 }, { 104,   0 }, { 105,   0 }, { 106,   0 },
 { 107,   0 }, { 108,   0 }, { 109,   0 }, { 110,   0 }, { 111,   0 },
 { 112,   0 }, { 113,   0 }, { 114,   0 }, { 115,   0 }, { 116,   0 },

 { 117,   0 }, { 118,   0 }, { 119,   0 }, { 120,   0 }, { 121,   0 },
 { 122,   0 }, { 123,   0 }, { 124,   0 }, { 125,   0 }, { 126,   0 },
 { 127,   0 }, { 128,   0 }, { 129,   0 }, { 130,   0 }, { 131,   0 },
 { 132,   0 }, { 133,   0 }, { 134,   0 }, { 135,   0 }, { 136,   0 },
 { 137,   0 }, { 138,   0 }, { 139,   0 }, { 140,   0 }, { 141,   0 },
 { 142,   0 }, { 143,   0 }, { 144,   0 }, { 145,   0 }, { 146,   0 },
 { 147,   0 }, { 148,   0 }, { 149,   0 }, { 150,   0 }, { 151,   0 },
 { 152,   0 }, { 153,   0 }, { 154,   0 }, { 155,   0 }, { 156,   0 },
 { 157,   0 }, { 158,   0 }, { 159,   0 }, { 160,   0 }, { 161,   0 },
 { 162,   0 }, { 163,   0 }, { 164,   0 }, { 165,   0 }, { 166,   0 },

 { 167,   0 }, { 168,   0 }, { 169,   0 }, { 170,   0 }, { 171,   0 },
 { 172,   0 }, { 173,   0 }, { 174,   0 }, { 175,   0 }, { 176,   0 },
 { 177,   0 }, { 178,   0 }, { 179,   0 }, { 180,   0 }, { 181,   0 },
 { 182,   0 }, { 183,   0 }, { 184,   0 }, { 185,   0 }, { 186,   0 },
 { 187,   0 }, { 188,   0 }, { 189,   0 }, { 190,   0 }, { 191,   0 },
 { 192,   0 }, { 193,   0 }, { 194,   0 }, { 195,   0 }, { 196,   0 },
 { 197,   0 }, { 198,   0 }, { 199,   0 }, { 200,   0 }, { 201,   0 },
 { 202,   0 }, { 203,   0 }, { 204,   0 }, { 205,   0 }, { 206,   0 },
 { 207,   0 }, { 208,   0 }, { 209,   0 }, { 210,   0 }, { 211,   0 },
 { 212,   0 }, { 213,   0 }, { 214,   0 }, { 215,   0 }, { 216,   0 },

 { 217,   0 }, { 218,   0 }, { 219,   0 }, { 220,   0 }, { 221,   0 },
 { 222,   0 }, { 223,   0 }, { 224,   0 }, { 225,   0 }, { 226,   0 },
 { 227,   0 }, { 228,   0 }, { 229,   0 }, { 230,   0 }, { 231,   0 },
 { 232,   0 }, { 233,   0 }, { 234,   0 }, { 235,   0 }, { 236,   0 },
 { 237,   0 }, { 238,   0 }, { 239,   0 }, { 240,   0 }, { 241,   0 },
 { 242,   0 }, { 243,   0 }, { 244,   0 }, { 245,   0 }, { 246,   0 },
 { 247,   0 }, { 248,   0 }, { 249,   0 }, { 250,   0 }, { 251,   0 },
 { 252,   0 }, { 253,   0 }, { 254,   0 }, { 255,   0 }, { 256,   0 },
 {   0,  14 }, {   0,2593 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  48,   0 },
 {  49,   0 }, {  50,   0 }, {  51,   0 }, {  52,   0 }, {  53,   0 },
 {  54,   0 }, {  55,   0 }, {  56,   0 }, {  57,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  65,   0 }, {  66,   0 }, {  67,   0 }, {  68,   0 },
 {  69,   0 }, {  70,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  97,   0 }, {  98,   0 },
 {  99,   0 }, { 100,   0 }, { 101,   0 }, { 102,   0 }, {   0,  10 },
 {   0,2489 }, {   1,   0 }, {   2,   0 }, {   3,   0 }, {   4,   0 },

 {   5,   0 }, {   6,   0 }, {   7,   0 }, {   8,   0 }, {   9,   0 },
 {   0,   0 }, {  11,   0 }, {  12,   0 }, {   0,   0 }, {  14,   0 },
 {  15,   0 }, {  16,   0 }, {  17,   0 }, {  18,   0 }, {  19,   0 },
 {  20,   0 }, {  21,   0 }, {  22,   0 }, {  23,   0 }, {  24,   0 },
 {  25,   0 }, {  26,   0 }, {  27,   0 }, {  28,   0 }, {  29,   0 },
 {  30,   0 }, {  31,   0 }, {  32,   0 }, {  33,   0 }, {  34,   0 },
 {  35,   0 }, {  36,   0 }, {  37,   0 }, {  38,   0 }, {  39,-1677 },
 {  40,   0 }, {  41,   0 }, {  42,   0 }, {  43,   0 }, {  44,   0 },
 {  45,   0 }, {  46,   0 }, {  47,   0 }, {  48,   0 }, {  49,   0 },
 {  50,   0 }, {  51,   0 }, {  52,   0 }, {  53,   0 }, {  54,   0 },

 {  55,   0 }, {  56,   0 }, {  57,   0 }, {  58,   0 }, {  59,   0 },
 {  60,   0 }, {  61,   0 }, {  62,   0 }, {  63,   0 }, {  64,   0 },
 {  65,   0 }, {  66,   0 }, {  67,   0 }, {  68,   0 }, {  69,   0 },
 {  70,   0 }, {  71,   0 }, {  72,   0 }, {  73,   0 }, {  74,   0 },
 {  75,   0 }, {  76,   0 }, {  77,   0 }, {  78,   0 }, {  79,   0 },
 {  80,   0 }, {  81,   0 }, {  82,   0 }, {  83,   0 }, {  84,   0 },
 {  85,   0 }, {  86,   0 }, {  87,   0 }, {  88,   0 }, {  89,   0 },
 {  90,   0 }, {  91,   0 }, {  92,   0 }, {  93,   0 }, {  94,   0 },
 {  95,   0 }, {  96,   0 }, {  97,   0 }, {  98,   0 }, {  99,   0 },
 { 100,   0 }, { 101,   0 }, { 102,   0 }, { 103,   0 }, { 104,   0 },

 { 105,   0 }, { 106,   0 }, { 107,   0 }, { 108,   0 }, { 109,   0 },
 { 110,   0 }, { 111,   0 }, { 112,   0 }, { 113,   0 }, { 114,   0 },
 { 115,   0 }, { 116,   0 }, { 117,   0 }, { 118,   0 }, { 119,   0 },
 { 120,   0 }, { 121,   0 }, { 122,   0 }, { 123,   0 }, { 124,   0 },
 { 125,   0 }, { 126,   0 }, { 127,   0 }, { 128,   0 }, { 129,   0 },
 { 130,   0 }, { 131,   0 }, { 132,   0 }, { 133,   0 }, { 134,   0 },
 { 135,   0 }, { 136,   0 }, { 137,   0 }, { 138,   0 }, { 139,   0 },
 { 140,   0 }, { 141,   0 }, { 142,   0 }, { 143,   0 }, { 144,   0 },
 { 145,   0 }, { 146,   0 }, { 147,   0 }, { 148,   0 }, { 149,   0 },
 { 150,   0 }, { 151,   0 }, { 152,   0 }, { 153,   0 }, { 154,   0 },

 { 155,   0 }, { 156,   0 }, { 157,   0 }, { 158,   0 }, { 159,   0 },
 { 160,   0 }, { 161,   0 }, { 162,   0 }, { 163,   0 }, { 164,   0 },
 { 165,   0 }, { 166,   0 }, { 167,   0 }, { 168,   0 }, { 169,   0 },
 { 170,   0 }, { 171,   0 }, { 172,   0 }, { 173,   0 }, { 174,   0 },
 { 175,   0 }, { 176,   0 }, { 177,   0 }, { 178,   0 }, { 179,   0 },
 { 180,   0 }, { 181,   0 }, { 182,   0 }, { 183,   0 }, { 184,   0 },
 { 185,   0 }, { 186,   0 }, { 187,   0 }, { 188,   0 }, { 189,   0 },
 { 190,   0 }, { 191,   0 }, { 192,   0 }, { 193,   0 }, { 194,   0 },
 { 195,   0 }, { 196,   0 }, { 197,   0 }, { 198,   0 }, { 199,   0 },
 { 200,   0 }, { 201,   0 }, { 202,   0 }, { 203,   0 }, { 204,   0 },

 { 205,   0 }, { 206,   0 }, { 207,   0 }, { 208,   0 }, { 209,   0 },
 { 210,   0 }, { 211,   0 }, { 212,   0 }, { 213,   0 }, { 214,   0 },
 { 215,   0 }, { 216,   0 }, { 217,   0 }, { 218,   0 }, { 219,   0 },
 { 220,   0 }, { 221,   0 }, { 222,   0 }, { 223,   0 }, { 224,   0 },
 { 225,   0 }, { 226,   0 }, { 227,   0 }, { 228,   0 }, { 229,   0 },
 { 230,   0 }, { 231,   0 }, { 232,   0 }, { 233,   0 }, { 234,   0 },
 { 235,   0 }, { 236,   0 }, { 237,   0 }, { 238,   0 }, { 239,   0 },
 { 240,   0 }, { 241,   0 }, { 242,   0 }, { 243,   0 }, { 244,   0 },
 { 245,   0 }, { 246,   0 }, { 247,   0 }, { 248,   0 }, { 249,   0 },
 { 250,   0 }, { 251,   0 }, { 252,   0 }, { 253,   0 }, { 254,   0 },

 { 255,   0 }, { 256,   0 }, {   0,   0 }, {   0,2231 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   9,   0 }, {   0,   0 }, {   0,   0 },
 {  12,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  32,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  65, 124 }, {  66, 248 },
 {  67, 248 }, {  68, 248 }, {  69, 248 }, {  70, 248 }, {  71, 248 },
 {  72, 248 }, {  73, 248 }, {  74, 248 }, {  75, 248 }, {  76, 248 },
 {  77, 248 }, {  78, 248 }, {  79, 248 }, {  80, 248 }, {  81, 248 },
 {  82, 248 }, {  83, 248 }, {  84, 248 }, {  85, 248 }, {  86, 248 },
 {  87, 248 }, {  88, 248 }, {  89, 248 }, {  90, 248 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  95, 248 }, {   0,   0 },

 {  97, 124 }, {  98, 248 }, {  99, 248 }, { 100, 248 }, { 101, 248 },
 { 102, 248 }, { 103, 248 }, { 104, 248 }, { 105, 248 }, { 106, 248 },
 { 107, 248 }, { 108, 248 }, { 109, 248 }, { 110, 248 }, { 111, 248 },
 { 112, 248 }, { 113, 248 }, { 114, 248 }, { 115, 248 }, { 116, 248 },
 { 117, 248 }, { 118, 248 }, { 119, 248 }, { 120, 248 }, { 121, 248 },
 { 122, 248 }, {   0,   6 }, {   0,2107 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   9,-1618 }, {   0,   0 }, {   0,   0 }, {  12,-1618 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,-1618 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  48,1574 }, {  49,1574 }, {  50,1574 }, {  51,1574 }, {  52,1574 },
 {  53,1574 }, {  54,1574 }, {  55,1574 }, {  56,1574 }, {  57,1574 },
 {  58,-1616 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  65,1574 }, {  66,1574 }, {  67,1574 },
 {  68,1574 }, {  69,1574 }, {  70,1698 }, {  71,1574 }, {  72,1574 },

 {  73,1574 }, {  74,1574 }, {  75,1574 }, {  76,1574 }, {  77,1574 },
 {  78,1574 }, {  79,1574 }, {  80,1574 }, {  81,1574 }, {  82,1574 },
 {  83,1574 }, {  84,1574 }, {  85,1574 }, {  86,1574 }, {  87,1574 },
 {  88,1574 }, {  89,1574 }, {  90,1574 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  95,1574 }, {   0,   0 }, {  97,1574 },
 {  98,1574 }, {  99,1574 }, { 100,1574 }, { 101,1574 }, { 102,1698 },
 { 103,1574 }, { 104,1574 }, { 105,1574 }, { 106,1574 }, { 107,1574 },
 { 108,1574 }, { 109,1574 }, { 110,1574 }, { 111,1574 }, { 112,1574 },
 { 113,1574 }, { 114,1574 }, { 115,1574 }, { 116,1574 }, { 117,1574 },
 { 118,1574 }, { 119,1574 }, { 120,1574 }, { 121,1574 }, { 122,1574 },

 {   0,   6 }, {   0,1983 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   9,-1742 }, {   0,   0 }, {   0,   0 }, {  12,-1742 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,-1742 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  48,1450 },

 {  49,1450 }, {  50,1450 }, {  51,1450 }, {  52,1450 }, {  53,1450 },
 {  54,1450 }, {  55,1450 }, {  56,1450 }, {  57,1450 }, {  58,-1740 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  65,1450 }, {  66,1450 }, {  67,1450 }, {  68,1450 },
 {  69,1450 }, {  70,1450 }, {  71,1450 }, {  72,1450 }, {  73,1450 },
 {  74,1450 }, {  75,1450 }, {  76,1450 }, {  77,1450 }, {  78,1450 },
 {  79,1450 }, {  80,1450 }, {  81,1450 }, {  82,1450 }, {  83,1450 },
 {  84,1450 }, {  85,1450 }, {  86,1450 }, {  87,1450 }, {  88,1450 },
 {  89,1450 }, {  90,1450 }, {   0,  12 }, {   0,1891 }, {   0,   0 },
 {   0,   0 }, {  95,1450 }, {   0,   0 }, {  97,1450 }, {  98,1450 },

 {  99,1450 }, { 100,1450 }, { 101,1450 }, { 102,1450 }, { 103,1450 },
 { 104,1450 }, { 105,1450 }, { 106,1450 }, { 107,1450 }, { 108,1450 },
 { 109,1450 }, { 110,1450 }, { 111,1450 }, { 112,1450 }, { 113,1450 },
 { 114,1450 }, { 115,1450 }, { 116,1450 }, { 117,1450 }, { 118,1450 },
 { 119,1450 }, { 120,1450 }, { 121,1450 }, { 122,1450 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  48,   0 }, {  49,   0 }, {  50,  59 }, {  51,  59 },
 {  52,  59 }, {  53,  59 }, {  54,  59 }, {  55,  59 }, {  56,  59 },

 {  57,  59 }, {   0,  12 }, {   0,1832 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  65, 118 }, {  66, 240 },
 {  67, 118 }, {  68, 118 }, {  69, 118 }, {  70, 118 }, {   0,   0 },
 {  72,-2257 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  97, 118 }, {  98, 240 }, {  99, 118 }, { 100, 118 }, { 101, 118 },
 { 102, 118 }, {   0,   0 }, { 104,-2257 }, {   0,   0 }, {   0,   0 },

 {  48,   0 }, {  49,   0 }, {  50,   0 }, {  51,   0 }, {  52,   0 },
 {  53,   0 }, {  54,   0 }, {  55,   0 }, {  56,   0 }, {  57,   0 },
 {   0,   0 }, {   0,1773 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  65,  59 }, {  66,  59 }, {  67,  59 },
 {  68,  59 }, {  69,  59 }, {  70,  59 }, {   0,   0 }, {  72,-2316 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  97,  59 },

 {  98,  59 }, {  99,  59 }, { 100,  59 }, { 101,  59 }, { 102,  59 },
 {   0,   0 }, { 104,-2316 }, {   0,   0 }, {   0,   0 }, {  48,   0 },
 {  49,   0 }, {  50,   0 }, {  51,   0 }, {  52,   0 }, {  53,   0 },
 {  54,   0 }, {  55,   0 }, {  56,   0 }, {  57,   0 }, {   0,  16 },
 {   0,1714 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  65,   0 }, {  66,   0 }, {  67,   0 }, {  68,   0 },
 {  69,   0 }, {  70,   0 }, {   0,   0 }, {  72,-2375 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,1689 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  97,   0 }, {  98,   0 },
 {  99,   0 }, { 100,   0 }, { 101,   0 }, { 102,   0 }, {   0,   0 },
 { 104,-2375 }, {   0,   0 }, {   0,   0 }, {  48,1397 }, {  49,1397 },
 {  50, -59 }, {  51, -59 }, {  52, -59 }, {  53, -59 }, {  54, -59 },
 {  55, -59 }, {  56, -59 }, {  57, -59 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,  16 }, {   0,1651 }, {   0,   0 },
 {  65, -59 }, {  66, -59 }, {  67, -59 }, {  68, -59 }, {  69, -59 },
 {  70, -59 }, {   0,   0 }, {  72,-2434 }, {  48,1431 }, {  49,1431 },
 {  50,1431 }, {  51,1431 }, {  52,1431 }, {  53,1431 }, {  54,1431 },

 {  55,1431 }, {  56,1431 }, {  57,1431 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  65,1431 }, {  66,1431 }, {  67,1431 }, {  68,1431 }, {  69,1431 },
 {  70,1431 }, {   0,   0 }, {  97, -59 }, {  98, -59 }, {  99, -59 },
 { 100, -59 }, { 101, -59 }, { 102, -59 }, {   0,   0 }, { 104,-2434 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  48,-122 }, {  49,-122 }, {  50,-122 }, {  51,-122 },
 {  52,-122 }, {  53,-122 }, {  54,-122 }, {  55,-122 }, {  56,-122 },
 {  57,-122 }, {   0,   0 }, {  97,1431 }, {  98,1431 }, {  99,1431 },
 { 100,1431 }, { 101,1431 }, { 102,1431 }, {  65,-122 }, {  66,-122 },

 {  67,-122 }, {  68,-122 }, {  69,-122 }, {  70,-122 }, {   0,   0 },
 {  72,-2497 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  97,-122 }, {  98,-122 }, {  99,-122 }, { 100,-122 }, { 101,-122 },
 { 102,-122 }, {   0,   0 }, { 104,-2497 }, {   0,   4 }, {   0,1545 },
 {   1,   0 }, {   2,   0 }, {   3,   0 }, {   4,   0 }, {   5,   0 },
 {   6,   0 }, {   7,   0 }, {   8,   0 }, {   9,   0 }, {   0,   0 },

 {  11,   0 }, {  12,   0 }, {  13,   0 }, {  14,   0 }, {  15,   0 },
 {  16,   0 }, {  17,   0 }, {  18,   0 }, {  19,   0 }, {  20,   0 },
 {  21,   0 }, {  22,   0 }, {  23,   0 }, {  24,   0 }, {  25,   0 },
 {  26,   0 }, {  27,   0 }, {  28,   0 }, {  29,   0 }, {  30,   0 },
 {  31,   0 }, {  32,   0 }, {  33,   0 }, {  34,   0 }, {  35,   0 },
 {  36,   0 }, {  37,   0 }, {  38,   0 }, {  39,   0 }, {  40,   0 },
 {  41,   0 }, {  42,   0 }, {  43,   0 }, {  44,   0 }, {  45,   0 },
 {  46,   0 }, {  47,   0 }, {  48,   0 }, {  49,   0 }, {  50,   0 },
 {  51,   0 }, {  52,   0 }, {  53,   0 }, {  54,   0 }, {  55,   0 },
 {  56,   0 }, {  57,   0 }, {  58,   0 }, {  59,   0 }, {  60,   0 },

 {  61,   0 }, {  62,   0 }, {  63,   0 }, {  64,   0 }, {  65,   0 },
 {  66,   0 }, {  67,   0 }, {  68,   0 }, {  69,   0 }, {  70,   0 },
 {  71,   0 }, {  72,   0 }, {  73,   0 }, {  74,   0 }, {  75,   0 },
 {  76,   0 }, {  77,   0 }, {  78,   0 }, {  79,   0 }, {  80,   0 },
 {  81,   0 }, {  82,   0 }, {  83,   0 }, {  84,   0 }, {  85,   0 },
 {  86,   0 }, {  87,   0 }, {  88,   0 }, {  89,   0 }, {  90,   0 },
 {  91,   0 }, {  92,   0 }, {  93,   0 }, {  94,   0 }, {  95,   0 },
 {  96,   0 }, {  97,   0 }, {  98,   0 }, {  99,   0 }, { 100,   0 },
 { 101,   0 }, { 102,   0 }, { 103,   0 }, { 104,   0 }, { 105,   0 },
 { 106,   0 }, { 107,   0 }, { 108,   0 }, { 109,   0 }, { 110,   0 },

 { 111,   0 }, { 112,   0 }, { 113,   0 }, { 114,   0 }, { 115,   0 },
 { 116,   0 }, { 117,   0 }, { 118,   0 }, { 119,   0 }, { 120,   0 },
 { 121,   0 }, { 122,   0 }, { 123,   0 }, { 124,   0 }, { 125,   0 },
 { 126,   0 }, { 127,   0 }, { 128,   0 }, { 129,   0 }, { 130,   0 },
 { 131,   0 }, { 132,   0 }, { 133,   0 }, { 134,   0 }, { 135,   0 },
 { 136,   0 }, { 137,   0 }, { 138,   0 }, { 139,   0 }, { 140,   0 },
 { 141,   0 }, { 142,   0 }, { 143,   0 }, { 144,   0 }, { 145,   0 },
 { 146,   0 }, { 147,   0 }, { 148,   0 }, { 149,   0 }, { 150,   0 },
 { 151,   0 }, { 152,   0 }, { 153,   0 }, { 154,   0 }, { 155,   0 },
 { 156,   0 }, { 157,   0 }, { 158,   0 }, { 159,   0 }, { 160,   0 },

 { 161,   0 }, { 162,   0 }, { 163,   0 }, { 164,   0 }, { 165,   0 },
 { 166,   0 }, { 167,   0 }, { 168,   0 }, { 169,   0 }, { 170,   0 },
 { 171,   0 }, { 172,   0 }, { 173,   0 }, { 174,   0 }, { 175,   0 },
 { 176,   0 }, { 177,   0 }, { 178,   0 }, { 179,   0 }, { 180,   0 },
 { 181,   0 }, { 182,   0 }, { 183,   0 }, { 184,   0 }, { 185,   0 },
 { 186,   0 }, { 187,   0 }, { 188,   0 }, { 189,   0 }, { 190,   0 },
 { 191,   0 }, { 192,   0 }, { 193,   0 }, { 194,   0 }, { 195,   0 },
 { 196,   0 }, { 197,   0 }, { 198,   0 }, { 199,   0 }, { 200,   0 },
 { 201,   0 }, { 202,   0 }, { 203,   0 }, { 204,   0 }, { 205,   0 },
 { 206,   0 }, { 207,   0 }, { 208,   0 }, { 209,   0 }, { 210,   0 },

 { 211,   0 }, { 212,   0 }, { 213,   0 }, { 214,   0 }, { 215,   0 },
 { 216,   0 }, { 217,   0 }, { 218,   0 }, { 219,   0 }, { 220,   0 },
 { 221,   0 }, { 222,   0 }, { 223,   0 }, { 224,   0 }, { 225,   0 },
 { 226,   0 }, { 227,   0 }, { 228,   0 }, { 229,   0 }, { 230,   0 },
 { 231,   0 }, { 232,   0 }, { 233,   0 }, { 234,   0 }, { 235,   0 },
 { 236,   0 }, { 237,   0 }, { 238,   0 }, { 239,   0 }, { 240,   0 },
 { 241,   0 }, { 242,   0 }, { 243,   0 }, { 244,   0 }, { 245,   0 },
 { 246,   0 }, { 247,   0 }, { 248,   0 }, { 249,   0 }, { 250,   0 },
 { 251,   0 }, { 252,   0 }, { 253,   0 }, { 254,   0 }, { 255,   0 },
 { 256,   0 }, {   0,   5 }, {   0,1287 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   9,-2801 }, {   0,   0 }, {   0,   0 }, {  12,-2801 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,-2801 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  48,   0 }, {  49,   0 }, {  50,   0 }, {  51,   0 }, {  52,   0 },

 {  53,   0 }, {  54,   0 }, {  55,   0 }, {  56,   0 }, {  57,   0 },
 {  58,-2790 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  65,   0 }, {  66,   0 }, {  67,   0 },
 {  68,   0 }, {  69,   0 }, {  70,   0 }, {  71,   0 }, {  72,   0 },
 {  73,   0 }, {  74,   0 }, {  75,   0 }, {  76,   0 }, {  77,   0 },
 {  78,   0 }, {  79,   0 }, {  80,   0 }, {  81,   0 }, {  82,   0 },
 {  83,   0 }, {  84,   0 }, {  85,   0 }, {  86,   0 }, {  87,   0 },
 {  88,   0 }, {  89,   0 }, {  90,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  95,   0 }, {   0,   0 }, {  97,   0 },
 {  98,   0 }, {  99,   0 }, { 100,   0 }, { 101,   0 }, { 102,   0 },

 { 103,   0 }, { 104,   0 }, { 105,   0 }, { 106,   0 }, { 107,   0 },
 { 108,   0 }, { 109,   0 }, { 110,   0 }, { 111,   0 }, { 112,   0 },
 { 113,   0 }, { 114,   0 }, { 115,   0 }, { 116,   0 }, { 117,   0 },
 { 118,   0 }, { 119,   0 }, { 120,   0 }, { 121,   0 }, { 122,   0 },
 {   0,   5 }, {   0,1163 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   9,-2925 }, {   0,   0 }, {   0,   0 }, {  12,-2925 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,-2925 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  39,-2440 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  48,-124 },
 {  49,-124 }, {  50,-124 }, {  51,-124 }, {  52,-124 }, {  53,-124 },
 {  54,-124 }, {  55,-124 }, {  56,-124 }, {  57,-124 }, {  58,-2914 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  65,-124 }, {  66,-124 }, {  67,-124 }, {  68,-124 },
 {  69,-124 }, {  70,-124 }, {  71,-124 }, {  72,-124 }, {  73,-124 },
 {  74,-124 }, {  75,-124 }, {  76,-124 }, {  77,-124 }, {  78,-124 },

 {  79,-124 }, {  80,-124 }, {  81,-124 }, {  82,-124 }, {  83,-124 },
 {  84,-124 }, {  85,-124 }, {  86,-124 }, {  87,-124 }, {  88,-124 },
 {  89,-124 }, {  90,-124 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  95,-124 }, {   0,   0 }, {  97,-124 }, {  98,-124 },
 {  99,-124 }, { 100,-124 }, { 101,-124 }, { 102,-124 }, { 103,-124 },
 { 104,-124 }, { 105,-124 }, { 106,-124 }, { 107,-124 }, { 108,-124 },
 { 109,-124 }, { 110,-124 }, { 111,-124 }, { 112,-124 }, { 113,-124 },
 { 114,-124 }, { 115,-124 }, { 116,-124 }, { 117,-124 }, { 118,-124 },
 { 119,-124 }, { 120,-124 }, { 121,-124 }, { 122,-124 }, {   0,   1 },
 {   0,1039 }, {   1,   0 }, {   2,   0 }, {   3,   0 }, {   4,   0 },

 {   5,   0 }, {   6,   0 }, {   7,   0 }, {   8,   0 }, {   9,   0 },
 {  10,-3033 }, {  11,   0 }, {  12,   0 }, {  13,-3031 }, {  14,   0 },
 {  15,   0 }, {  16,   0 }, {  17,   0 }, {  18,   0 }, {  19,   0 },
 {  20,   0 }, {  21,   0 }, {  22,   0 }, {  23,   0 }, {  24,   0 },
 {  25,   0 }, {  26,   0 }, {  27,   0 }, {  28,   0 }, {  29,   0 },
 {  30,   0 }, {  31,   0 }, {  32,   0 }, {  33,   0 }, {  34,   0 },
 {  35,   0 }, {  36,   0 }, {  37,   0 }, {  38,   0 }, {  39,   0 },
 {  40,   0 }, {  41,   0 }, {  42,   0 }, {  43,   0 }, {  44,   0 },
 {  45,   0 }, {  46,   0 }, {  47,   0 }, {  48,   0 }, {  49,   0 },
 {  50,   0 }, {  51,   0 }, {  52,   0 }, {  53,   0 }, {  54,   0 },

 {  55,   0 }, {  56,   0 }, {  57,   0 }, {  58,   0 }, {  59,   0 },
 {  60,   0 }, {  61,   0 }, {  62,   0 }, {  63,   0 }, {  64,   0 },
 {  65,   0 }, {  66,   0 }, {  67,   0 }, {  68,   0 }, {  69,   0 },
 {  70,   0 }, {  71,   0 }, {  72,   0 }, {  73,   0 }, {  74,   0 },
 {  75,   0 }, {  76,   0 }, {  77,   0 }, {  78,   0 }, {  79,   0 },
 {  80,   0 }, {  81,   0 }, {  82,   0 }, {  83,   0 }, {  84,   0 },
 {  85,   0 }, {  86,   0 }, {  87,   0 }, {  88,   0 }, {  89,   0 },
 {  90,   0 }, {  91,   0 }, {  92,   0 }, {  93,   0 }, {  94,   0 },
 {  95,   0 }, {  96,   0 }, {  97,   0 }, {  98,   0 }, {  99,   0 },
 { 100,   0 }, { 101,   0 }, { 102,   0 }, { 103,   0 }, { 104,   0 },

 { 105,   0 }, { 106,   0 }, { 107,   0 }, { 108,   0 }, { 109,   0 },
 { 110,   0 }, { 111,   0 }, { 112,   0 }, { 113,   0 }, { 114,   0 },
 { 115,   0 }, { 116,   0 }, { 117,   0 }, { 118,   0 }, { 119,   0 },
 { 120,   0 }, { 121,   0 }, { 122,   0 }, { 123,   0 }, { 124,   0 },
 { 125,   0 }, { 126,   0 }, { 127,   0 }, { 128,   0 }, { 129,   0 },
 { 130,   0 }, { 131,   0 }, { 132,   0 }, { 133,   0 }, { 134,   0 },
 { 135,   0 }, { 136,   0 }, { 137,   0 }, { 138,   0 }, { 139,   0 },
 { 140,   0 }, { 141,   0 }, { 142,   0 }, { 143,   0 }, { 144,   0 },
 { 145,   0 }, { 146,   0 }, { 147,   0 }, { 148,   0 }, { 149,   0 },
 { 150,   0 }, { 151,   0 }, { 152,   0 }, { 153,   0 }, { 154,   0 },

 { 155,   0 }, { 156,   0 }, { 157,   0 }, { 158,   0 }, { 159,   0 },
 { 160,   0 }, { 161,   0 }, { 162,   0 }, { 163,   0 }, { 164,   0 },
 { 165,   0 }, { 166,   0 }, { 167,   0 }, { 168,   0 }, { 169,   0 },
 { 170,   0 }, { 171,   0 }, { 172,   0 }, { 173,   0 }, { 174,   0 },
 { 175,   0 }, { 176,   0 }, { 177,   0 }, { 178,   0 }, { 179,   0 },
 { 180,   0 }, { 181,   0 }, { 182,   0 }, { 183,   0 }, { 184,   0 },
 { 185,   0 }, { 186,   0 }, { 187,   0 }, { 188,   0 }, { 189,   0 },
 { 190,   0 }, { 191,   0 }, { 192,   0 }, { 193,   0 }, { 194,   0 },
 { 195,   0 }, { 196,   0 }, { 197,   0 }, { 198,   0 }, { 199,   0 },
 { 200,   0 }, { 201,   0 }, { 202,   0 }, { 203,   0 }, { 204,   0 },

 { 205,   0 }, { 206,   0 }, { 207,   0 }, { 208,   0 }, { 209,   0 },
 { 210,   0 }, { 211,   0 }, { 212,   0 }, { 213,   0 }, { 214,   0 },
 { 215,   0 }, { 216,   0 }, { 217,   0 }, { 218,   0 }, { 219,   0 },
 { 220,   0 }, { 221,   0 }, { 222,   0 }, { 223,   0 }, { 224,   0 },
 { 225,   0 }, { 226,   0 }, { 227,   0 }, { 228,   0 }, { 229,   0 },
 { 230,   0 }, { 231,   0 }, { 232,   0 }, { 233,   0 }, { 234,   0 },
 { 235,   0 }, { 236,   0 }, { 237,   0 }, { 238,   0 }, { 239,   0 },
 { 240,   0 }, { 241,   0 }, { 242,   0 }, { 243,   0 }, { 244,   0 },
 { 245,   0 }, { 246,   0 }, { 247,   0 }, { 248,   0 }, { 249,   0 },
 { 250,   0 }, { 251,   0 }, { 252,   0 }, { 253,   0 }, { 254,   0 },

 { 255,   0 }, { 256,   0 }, {   0,   0 }, {   0, 781 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   9,-3307 }, {   0,   0 }, {   0,   0 },
 {  12,-3307 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  32,-3307 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {  48,   0 }, {  49,   0 }, {  50,   0 }, {  51,   0 },
 {  52,   0 }, {  53,   0 }, {  54,   0 }, {  55,   0 }, {  56,   0 },
 {  57,   0 }, {  58,-3296 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  65,   0 }, {  66,   0 },
 {  67,   0 }, {  68,   0 }, {  69,   0 }, {  70,   0 }, {  71,   0 },
 {  72,   0 }, {  73,   0 }, {  74,   0 }, {  75,   0 }, {  76,   0 },
 {  77,   0 }, {  78,   0 }, {  79,   0 }, {  80,   0 }, {  81,   0 },
 {  82,   0 }, {  83,   0 }, {  84,   0 }, {  85,   0 }, {  86,   0 },
 {  87,   0 }, {  88,   0 }, {  89,   0 }, {  90,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  95,   0 }, {   0,   0 },

 {  97,   0 }, {  98,   0 }, {  99,   0 }, { 100,   0 }, { 101,   0 },
 { 102,   0 }, { 103,   0 }, { 104,   0 }, { 105,   0 }, { 106,   0 },
 { 107,   0 }, { 108,   0 }, { 109,   0 }, { 110,   0 }, { 111,   0 },
 { 112,   0 }, { 113,   0 }, { 114,   0 }, { 115,   0 }, { 116,   0 },
 { 117,   0 }, { 118,   0 }, { 119,   0 }, { 120,   0 }, { 121,   0 },
 { 122,   0 }, {   0,   0 }, {   0, 657 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   9,-3431 }, {   0,   0 }, {   0,   0 }, {  12,-3431 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,-3431 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  39,-2944 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  48,-124 }, {  49,-124 }, {  50,-124 }, {  51,-124 }, {  52,-124 },
 {  53,-124 }, {  54,-124 }, {  55,-124 }, {  56,-124 }, {  57,-124 },
 {  58,-3420 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  65,-124 }, {  66,-124 }, {  67,-124 },
 {  68,-124 }, {  69,-124 }, {  70,-124 }, {  71,-124 }, {  72,-124 },

 {  73,-124 }, {  74,-124 }, {  75,-124 }, {  76,-124 }, {  77,-124 },
 {  78,-124 }, {  79,-124 }, {  80,-124 }, {  81,-124 }, {  82,-124 },
 {  83,-124 }, {  84,-124 }, {  85,-124 }, {  86,-124 }, {  87,-124 },
 {  88,-124 }, {  89,-124 }, {  90,-124 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  95,-124 }, {   0,   0 }, {  97,-124 },
 {  98,-124 }, {  99,-124 }, { 100,-124 }, { 101,-124 }, { 102,-124 },
 { 103,-124 }, { 104,-124 }, { 105,-124 }, { 106,-124 }, { 107,-124 },
 { 108,-124 }, { 109,-124 }, { 110,-124 }, { 111,-124 }, { 112,-124 },
 { 113,-124 }, { 114,-124 }, { 115,-124 }, { 116,-124 }, { 117,-124 },
 { 118,-124 }, { 119,-124 }, { 120,-124 }, { 121,-124 }, { 122,-124 },

 {   0,   6 }, {   0, 533 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   9,-3192 }, {   0,   0 }, {   0,   0 }, {  12,-3192 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  32,-3192 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  48,   0 },

 {  49,   0 }, {  50,   0 }, {  51,   0 }, {  52,   0 }, {  53,   0 },
 {  54,   0 }, {  55,   0 }, {  56,   0 }, {  57,   0 }, {  58,-3190 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  65,   0 }, {  66,   0 }, {  67,   0 }, {  68,   0 },
 {  69,   0 }, {  70,   0 }, {  71,   0 }, {  72,   0 }, {  73,   0 },
 {  74,   0 }, {  75,   0 }, {  76,   0 }, {  77,   0 }, {  78,   0 },
 {  79,   0 }, {  80,   0 }, {  81,   0 }, {  82,   0 }, {  83,   0 },
 {  84,   0 }, {  85,   0 }, {  86,   0 }, {  87,   0 }, {  88,   0 },
 {  89,   0 }, {  90,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  95,   0 }, {   0,   0 }, {  97,   0 }, {  98,   0 },

 {  99,   0 }, { 100,   0 }, { 101,   0 }, { 102,   0 }, { 103,   0 },
 { 104,   0 }, { 105,   0 }, { 106,   0 }, { 107,   0 }, { 108,   0 },
 { 109,   0 }, { 110,   0 }, { 111,   0 }, { 112,   0 }, { 113,   0 },
 { 114,   0 }, { 115,   0 }, { 116,   0 }, { 117,   0 }, { 118,   0 },
 { 119,   0 }, { 120,   0 }, { 121,   0 }, { 122,   0 }, {   0,   6 },
 {   0, 409 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   9,-3316 },
 {   0,   0 }, {   0,   0 }, {  12,-3316 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  32,-3316 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  39,-2812 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  48,-124 }, {  49,-124 },
 {  50,-124 }, {  51,-124 }, {  52,-124 }, {  53,-124 }, {  54,-124 },
 {  55,-124 }, {  56,-124 }, {  57,-124 }, {  58,-3314 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  65,-124 }, {  66,-124 }, {  67,-124 }, {  68,-124 }, {  69,-124 },
 {  70,-124 }, {  71,-124 }, {  72,-124 }, {  73,-124 }, {  74,-124 },

 {  75,-124 }, {  76,-124 }, {  77,-124 }, {  78,-124 }, {  79,-124 },
 {  80,-124 }, {  81,-124 }, {  82,-124 }, {  83,-124 }, {  84,-124 },
 {  85,-124 }, {  86,-124 }, {  87,-124 }, {  88,-124 }, {  89,-124 },
 {  90,-124 }, {   0,  18 }, {   0, 317 }, {   0,   0 }, {   0,   0 },
 {  95,-124 }, {   0,   0 }, {  97,-124 }, {  98,-124 }, {  99,-124 },
 { 100,-124 }, { 101,-124 }, { 102,-124 }, { 103,-124 }, { 104,-124 },
 { 105,-124 }, { 106,-124 }, { 107,-124 }, { 108,-124 }, { 109,-124 },
 { 110,-124 }, { 111,-124 }, { 112,-124 }, { 113,-124 }, { 114,-124 },
 { 115,-124 }, { 116,-124 }, { 117,-124 }, { 118,-124 }, { 119,-124 },
 { 120,-124 }, { 121,-124 }, { 122,-124 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {  48,   0 }, {  49,   0 }, {  50,-1456 }, {  51,-1456 }, {  52,-1456 },
 {  53,-1456 }, {  54,-1456 }, {  55,-1456 }, {  56,-1456 }, {  57,-1456 },
 {   0,  15 }, {   0, 258 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {  65,-1456 }, {  66,-1456 }, {  67,-1456 },
 {  68,-1456 }, {  69,-1456 }, {  70,-1456 }, {   0,   0 }, {  72,-3831 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {  97,-1456 },
 {  98,-1456 }, {  99,-1456 }, { 100,-1456 }, { 101,-1456 }, { 102,-1456 },
 {   0,   0 }, { 104,-3831 }, {   0,   0 }, {   0,   0 }, {  48,   0 },
 {  49,   0 }, {  50,   0 }, {  51,   0 }, {  52,   0 }, {  53,   0 },
 {  54,   0 }, {  55,   0 }, {  56,   0 }, {  57,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {  65,   0 }, {  66,   0 }, {  67,   0 }, {  68,   0 },
 {  69,   0 }, {  70,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {  97,   0 }, {  98,   0 },
 {  99,   0 }, { 100,   0 }, { 101,   0 }, { 102,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },

 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 }, {   0,   0 },
 {   0,   0 }, {   0,   0 }, {   0,   0 }, { 257,  33 }, {   1,   0 },
    };

static yyconst struct yy_trans_info *yy_start_state_list[5] =
    {
    &yy_transition[1],
    &yy_transition[3],
    &yy_transition[261],
    &yy_transition[519],
    &yy_transition[777],
    } ;

/* The intent behind this definition is that it'll catch
 * any uses of REJECT which flex missed.
 */
#define REJECT reject_used_but_not_detected
#define yymore() yymore_used_but_not_detected
#define YY_MORE_ADJ 0
#define YY_RESTORE_YY_MORE_OFFSET

#include "codearea.h"
#include "ctype.h"
#include "die.h"
#include "errors.h"
#include "listfile.h"
#include "options.h"
#include "srcfile.h"
#include "strutil.h"
#include "strpool.h"

/*-----------------------------------------------------------------------------
*   Types
*----------------------------------------------------------------------------*/

/* Stack of nested constructs on each context */
CLASS(Struct)
	int		id;					/* user-defined ID */
	int		value;				/* user-defined VALUE */
	int		line_nr;			/* line where struct started */
END_CLASS;
CLASS_LIST(Struct);

/* Scanner context - current input file/buffer */
CLASS(Context)
	yyscan_t	scanner;		/* current scanner object */

	FILE   *file; 				/* file handle */
	char   *filename;			/* file name - kept in strpool so that it is 
								   available after file has been closed */
	int 	line_nr;			/* input line number */
	int 	line_inc;			/* increment line number on each newline */
	
	BOOL	do_list;			/* true to output list lines */

	StructList *struct_stack;	/* stack of open structs, empty if none */
	
END_CLASS;

/* Scanner context - scack of contexts, top of stack is current */
CLASS_LIST(Context);

/* List of tokens for unget queue */

/* Scanner global data */
CLASS(Scan)
	ContextList	*contexts;			/* stack of input contexts */
	TokenList	*token_queue;		/* stack of pushed-back tokens */
	Token		*token;				/* last token */
END_CLASS;

/*-----------------------------------------------------------------------------
*   Globals
*----------------------------------------------------------------------------*/
static Scan *scan = NULL;

/*-----------------------------------------------------------------------------
*   Forward declatations
*----------------------------------------------------------------------------*/
static long scan_num (char *text, int num_suffix_chars, int base);
static Context *get_context( void );

/* init_scan() implemented as macro */
#define init_scan() if ( scan == NULL ) scan = OBJ_NEW( Scan )

/*-----------------------------------------------------------------------------
*   Configure scanner
*----------------------------------------------------------------------------*/

/* handle line number */
#define YY_USER_ACTION 														\
	scan->token->filename = context->filename;								\
	scan->token->line_nr  = context->line_nr;								\
	if ( !clinemode )														\
	{																		\
		set_error_line( scan->token->line_nr ); 							\
	}
	
#define YY_FATAL_ERROR(msg) 												\
	die( AssertionException, msg )

/*-----------------------------------------------------------------------------
*	Options
*----------------------------------------------------------------------------*/
#define YY_NO_UNISTD_H 1
/*-----------------------------------------------------------------------------
*	Start conditions
*----------------------------------------------------------------------------*/
/* start condition active to read whole line for list before scanning tokens */
		
/*-----------------------------------------------------------------------------
*	Rules
*----------------------------------------------------------------------------*/

#define INITIAL 0
#define READ_LINE 1

#ifndef YY_NO_UNISTD_H
/* Special case for "unistd.h", since it is non-ANSI. We include it way
 * down here because we want the user's section 1 to have been scanned first.
 * The user has a chance to override it with an option.
 */
#include <unistd.h>
#endif

#define YY_EXTRA_TYPE struct Context *

/* Holds the entire state of the reentrant scanner. */
struct yyguts_t
    {

    /* User-defined. Not touched by flex. */
    YY_EXTRA_TYPE yyextra_r;

    /* The rest are the same as the globals declared in the non-reentrant scanner. */
    FILE *yyin_r, *yyout_r;
    size_t yy_buffer_stack_top; /**< index of top of stack. */
    size_t yy_buffer_stack_max; /**< capacity of stack. */
    YY_BUFFER_STATE * yy_buffer_stack; /**< Stack as an array. */
    char yy_hold_char;
    int yy_n_chars;
    int yyleng_r;
    char *yy_c_buf_p;
    int yy_init;
    int yy_start;
    int yy_did_buffer_switch_on_eof;
    int yy_start_stack_ptr;
    int yy_start_stack_depth;
    int *yy_start_stack;
    yy_state_type yy_last_accepting_state;
    char* yy_last_accepting_cpos;

    int yylineno_r;
    int yy_flex_debug_r;

    char *yytext_r;
    int yy_more_flag;
    int yy_more_len;

    }; /* end struct yyguts_t */

static int yy_init_globals (yyscan_t yyscanner );

int yylex_init (yyscan_t* scanner);

int yylex_init_extra (YY_EXTRA_TYPE user_defined,yyscan_t* scanner);

/* Accessor methods to globals.
   These are made visible to non-reentrant scanners for convenience. */

int yylex_destroy (yyscan_t yyscanner );

int yyget_debug (yyscan_t yyscanner );

void yyset_debug (int debug_flag ,yyscan_t yyscanner );

YY_EXTRA_TYPE yyget_extra (yyscan_t yyscanner );

void yyset_extra (YY_EXTRA_TYPE user_defined ,yyscan_t yyscanner );

FILE *yyget_in (yyscan_t yyscanner );

void yyset_in  (FILE * in_str ,yyscan_t yyscanner );

FILE *yyget_out (yyscan_t yyscanner );

void yyset_out  (FILE * out_str ,yyscan_t yyscanner );

int yyget_leng (yyscan_t yyscanner );

char *yyget_text (yyscan_t yyscanner );

int yyget_lineno (yyscan_t yyscanner );

void yyset_lineno (int line_number ,yyscan_t yyscanner );

/* Macros after this point can all be overridden by user definitions in
 * section 1.
 */

#ifndef YY_SKIP_YYWRAP
#ifdef __cplusplus
extern "C" int yywrap (yyscan_t yyscanner );
#else
extern int yywrap (yyscan_t yyscanner );
#endif
#endif

    static void yyunput (int c,char *buf_ptr  ,yyscan_t yyscanner);
    
#ifndef yytext_ptr
static void yy_flex_strncpy (char *,yyconst char *,int ,yyscan_t yyscanner);
#endif

#ifdef YY_NEED_STRLEN
static int yy_flex_strlen (yyconst char * ,yyscan_t yyscanner);
#endif

#ifndef YY_NO_INPUT

#ifdef __cplusplus
static int yyinput (yyscan_t yyscanner );
#else
static int input (yyscan_t yyscanner );
#endif

#endif

/* Amount of stuff to slurp up with each read. */
#ifndef YY_READ_BUF_SIZE
#ifdef __ia64__
/* On IA-64, the buffer size is 16k, not 8k */
#define YY_READ_BUF_SIZE 16384
#else
#define YY_READ_BUF_SIZE 8192
#endif /* __ia64__ */
#endif

/* Copy whatever the last rule matched to the standard output. */
#ifndef ECHO
/* This used to be an fputs(), but since the string might contain NUL's,
 * we now use fwrite().
 */
#define ECHO do { if (fwrite( yytext, yyleng, 1, yyout )) {} } while (0)
#endif

/* Gets input and stuffs it into "buf".  number of characters read, or YY_NULL,
 * is returned in "result".
 */
#ifndef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	errno=0; \
	while ( (result = read( fileno(yyin), (char *) buf, max_size )) < 0 ) \
	{ \
		if( errno != EINTR) \
		{ \
			YY_FATAL_ERROR( "input in flex scanner failed" ); \
			break; \
		} \
		errno=0; \
		clearerr(yyin); \
	}\
\

#endif

/* No semi-colon after return; correct usage is to write "yyterminate();" -
 * we don't want an extra ';' after the "return" because that will cause
 * some compilers to complain about unreachable statements.
 */
#ifndef yyterminate
#define yyterminate() return YY_NULL
#endif

/* Number of entries by which start-condition stack grows. */
#ifndef YY_START_STACK_INCR
#define YY_START_STACK_INCR 25
#endif

/* Report a fatal error. */
#ifndef YY_FATAL_ERROR
#define YY_FATAL_ERROR(msg) yy_fatal_error( msg , yyscanner)
#endif

/* end tables serialization structures and prototypes */

/* Default declaration of generated scanner - a define so the user can
 * easily add parameters.
 */
#ifndef YY_DECL
#define YY_DECL_IS_OURS 1

extern int yylex (yyscan_t yyscanner);

#define YY_DECL int yylex (yyscan_t yyscanner)
#endif /* !YY_DECL */

/* Code executed at the beginning of each rule, after yytext and yyleng
 * have been set up.
 */
#ifndef YY_USER_ACTION
#define YY_USER_ACTION
#endif

/* Code executed at the end of each rule. */
#ifndef YY_BREAK
#define YY_BREAK break;
#endif

#define YY_RULE_SETUP \
	YY_USER_ACTION

/** The main scanner function which does all the work.
 */
YY_DECL
{
	register yy_state_type yy_current_state;
	register char *yy_cp, *yy_bp;
	register int yy_act;
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

			Context *context = yyget_extra(yyscanner );
			Token   *token   = scan->token;
			
			/* setup state for listing, if first call of file or first call
			   after newline */
			if ( context->do_list )
			{
				BEGIN( READ_LINE );
			}

			/* process list */

	if ( !yyg->yy_init )
		{
		yyg->yy_init = 1;

#ifdef YY_USER_INIT
		YY_USER_INIT;
#endif

		if ( ! yyg->yy_start )
			yyg->yy_start = 1;	/* first start state */

		if ( ! yyin )
			yyin = stdin;

		if ( ! yyout )
			yyout = stdout;

		if ( ! YY_CURRENT_BUFFER ) {
			yyensure_buffer_stack (yyscanner);
			YY_CURRENT_BUFFER_LVALUE =
				yy_create_buffer(yyin,YY_BUF_SIZE ,yyscanner);
		}

		yy_load_buffer_state(yyscanner );
		}

	while ( 1 )		/* loops until end-of-file is reached */
		{
		yy_cp = yyg->yy_c_buf_p;

		/* Support of yytext. */
		*yy_cp = yyg->yy_hold_char;

		/* yy_bp points to the position in yy_ch_buf of the start of
		 * the current run.
		 */
		yy_bp = yy_cp;

		yy_current_state = yy_start_state_list[yyg->yy_start];
yy_match:
		{
		register yyconst struct yy_trans_info *yy_trans_info;

		register YY_CHAR yy_c;

		for ( yy_c = YY_SC_TO_UI(*yy_cp);
		      (yy_trans_info = &yy_current_state[(unsigned int) yy_c])->
		yy_verify == yy_c;
		      yy_c = YY_SC_TO_UI(*++yy_cp) )
			{
			yy_current_state += yy_trans_info->yy_nxt;

			if ( yy_current_state[-1].yy_nxt )
				{
				yyg->yy_last_accepting_state = yy_current_state;
				yyg->yy_last_accepting_cpos = yy_cp;
				}
			}
		}

yy_find_action:
		yy_act = yy_current_state[-1].yy_nxt;

		YY_DO_BEFORE_ACTION;

do_action:	/* This label is used only to access EOF actions. */

		switch ( yy_act )
	{ /* beginning of action switch */
			case 0: /* must back up */
			/* undo the effects of YY_DO_BEFORE_ACTION */
			*yy_cp = yyg->yy_hold_char;
			yy_cp = yyg->yy_last_accepting_cpos + 1;
			yy_current_state = yyg->yy_last_accepting_state;
			goto yy_find_action;

case 1:
/* rule 1 can match eol */
YY_RULE_SETUP
{
				list_start_line( get_PC(), context->filename, context->line_nr, yytext );
				yyless( 0 );				/* push all text back to input */
				context->do_list = FALSE;
				BEGIN( INITIAL );
			}
	YY_BREAK
/* newline */
case 2:
/* rule 2 can match eol */
YY_RULE_SETUP
{
				context->line_nr += context->line_inc;		/* count lines */
				if ( listing && context->file != NULL )
				{
					context->do_list = TRUE;				/* READ_LINE on next scan */
				}
				return TOK_NEWLINE;
			}			
	YY_BREAK
case 3:
YY_RULE_SETUP
/* blanks */
	YY_BREAK
case 4:
YY_RULE_SETUP
/* comment */
	YY_BREAK
/* Identifier */
case 5:
YY_RULE_SETUP
{
				Str_bset( token->str_value, yytext, yyleng ); 	
				strtoupper( Str_data( token->str_value ) );		
				return TOK_NAME;
			}
	YY_BREAK
/* Label */
case 6:
case 7:
YY_RULE_SETUP
{
				/* trim starting dot and ending colon */
				while ( yytext[0] == '.' || isspace( yytext[0] ) ) 
				{
					yytext++;
					yyleng--;
				}
				while ( yytext[yyleng-1] == ':' || isspace( yytext[yyleng-1] ) ) 
				{
					yyleng--;
				}
				Str_bset( token->str_value, yytext, yyleng ); 	
				strtoupper( Str_data( token->str_value ) );		
				return TOK_LABEL;
			}
	YY_BREAK
/* String - return string without quotes */
case 8:
case 9:
YY_RULE_SETUP
{
				Str_bset( token->str_value, yytext+1, yyleng-2 ); 	
				return TOK_STRING;
			}
	YY_BREAK
case 10:
case 11:
YY_RULE_SETUP
error( ERR_UNCLOSED_STR );
	YY_BREAK
/* Number - return value in yyvalue */
case 12:
YY_RULE_SETUP
token->num_value = scan_num(yytext,     0, 10); return TOK_NUMBER;
	YY_BREAK
case 13:
YY_RULE_SETUP
token->num_value = scan_num(yytext,     1, 16); return TOK_NUMBER;
	YY_BREAK
case 14:
YY_RULE_SETUP
token->num_value = scan_num(yytext + 1, 0, 16); return TOK_NUMBER;
	YY_BREAK
case 15:
YY_RULE_SETUP
token->num_value = scan_num(yytext + 2, 0, 16); return TOK_NUMBER;
	YY_BREAK
case 16:
YY_RULE_SETUP
token->num_value = scan_num(yytext,     1,  2); return TOK_NUMBER;
	YY_BREAK
case 17:
YY_RULE_SETUP
token->num_value = scan_num(yytext + 1, 0,  2); return TOK_NUMBER;
	YY_BREAK
case 18:
YY_RULE_SETUP
token->num_value = scan_num(yytext + 2, 0,  2); return TOK_NUMBER;
	YY_BREAK
case 19:
YY_RULE_SETUP
token->num_value = scan_num(yytext + 2, 1,  2); return TOK_NUMBER;
	YY_BREAK
case 20:
YY_RULE_SETUP
token->num_value = scan_num(yytext + 2, 1,  2); return TOK_NUMBER;
	YY_BREAK
/* multi-char tokens */			
case 21:
YY_RULE_SETUP
return TOK_EQUAL_EQUAL;
	YY_BREAK
case 22:
YY_RULE_SETUP
return TOK_LESS_GREATER;
	YY_BREAK
case 23:
YY_RULE_SETUP
return TOK_NOT_EQUAL;
	YY_BREAK
case 24:
YY_RULE_SETUP
return TOK_LESS_EQUAL;
	YY_BREAK
case 25:
YY_RULE_SETUP
return TOK_GREATER_EQUAL;
	YY_BREAK
case 26:
YY_RULE_SETUP
return TOK_DBL_VBAR;
	YY_BREAK
case 27:
YY_RULE_SETUP
return TOK_DBL_AMPERSAND;
	YY_BREAK
case 28:
YY_RULE_SETUP
return TOK_DBL_LESS;
	YY_BREAK
case 29:
YY_RULE_SETUP
return TOK_DBL_GREATER;
	YY_BREAK
case 30:
YY_RULE_SETUP
return TOK_DBL_ASTERISK;
	YY_BREAK
/* default rule - one character token */
case 31:
YY_RULE_SETUP
return (TokType)yytext[0];
	YY_BREAK
case 32:
YY_RULE_SETUP
YY_FATAL_ERROR( "flex scanner jammed" );
	YY_BREAK
case YY_STATE_EOF(INITIAL):
case YY_STATE_EOF(READ_LINE):
	yyterminate();

	case YY_END_OF_BUFFER:
		{
		/* Amount of text matched not including the EOB char. */
		int yy_amount_of_matched_text = (int) (yy_cp - yyg->yytext_ptr) - 1;

		/* Undo the effects of YY_DO_BEFORE_ACTION. */
		*yy_cp = yyg->yy_hold_char;
		YY_RESTORE_YY_MORE_OFFSET

		if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_NEW )
			{
			/* We're scanning a new file or input source.  It's
			 * possible that this happened because the user
			 * just pointed yyin at a new source and called
			 * yylex().  If so, then we have to assure
			 * consistency between YY_CURRENT_BUFFER and our
			 * globals.  Here is the right place to do so, because
			 * this is the first action (other than possibly a
			 * back-up) that will match for the new input source.
			 */
			yyg->yy_n_chars = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
			YY_CURRENT_BUFFER_LVALUE->yy_input_file = yyin;
			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status = YY_BUFFER_NORMAL;
			}

		/* Note that here we test for yy_c_buf_p "<=" to the position
		 * of the first EOB in the buffer, since yy_c_buf_p will
		 * already have been incremented past the NUL character
		 * (since all states make transitions on EOB to the
		 * end-of-buffer state).  Contrast this with the test
		 * in input().
		 */
		if ( yyg->yy_c_buf_p <= &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[yyg->yy_n_chars] )
			{ /* This was really a NUL. */
			yy_state_type yy_next_state;

			yyg->yy_c_buf_p = yyg->yytext_ptr + yy_amount_of_matched_text;

			yy_current_state = yy_get_previous_state( yyscanner );

			/* Okay, we're now positioned to make the NUL
			 * transition.  We couldn't have
			 * yy_get_previous_state() go ahead and do it
			 * for us because it doesn't know how to deal
			 * with the possibility of jamming (and we don't
			 * want to build jamming into it because then it
			 * will run more slowly).
			 */

			yy_next_state = yy_try_NUL_trans( yy_current_state , yyscanner);

			yy_bp = yyg->yytext_ptr + YY_MORE_ADJ;

			if ( yy_next_state )
				{
				/* Consume the NUL. */
				yy_cp = ++yyg->yy_c_buf_p;
				yy_current_state = yy_next_state;
				goto yy_match;
				}

			else
				{
				yy_cp = yyg->yy_c_buf_p;
				goto yy_find_action;
				}
			}

		else switch ( yy_get_next_buffer( yyscanner ) )
			{
			case EOB_ACT_END_OF_FILE:
				{
				yyg->yy_did_buffer_switch_on_eof = 0;

				if ( yywrap(yyscanner ) )
					{
					/* Note: because we've taken care in
					 * yy_get_next_buffer() to have set up
					 * yytext, we can now set up
					 * yy_c_buf_p so that if some total
					 * hoser (like flex itself) wants to
					 * call the scanner after we return the
					 * YY_NULL, it'll still work - another
					 * YY_NULL will get returned.
					 */
					yyg->yy_c_buf_p = yyg->yytext_ptr + YY_MORE_ADJ;

					yy_act = YY_STATE_EOF(YY_START);
					goto do_action;
					}

				else
					{
					if ( ! yyg->yy_did_buffer_switch_on_eof )
						YY_NEW_FILE;
					}
				break;
				}

			case EOB_ACT_CONTINUE_SCAN:
				yyg->yy_c_buf_p =
					yyg->yytext_ptr + yy_amount_of_matched_text;

				yy_current_state = yy_get_previous_state( yyscanner );

				yy_cp = yyg->yy_c_buf_p;
				yy_bp = yyg->yytext_ptr + YY_MORE_ADJ;
				goto yy_match;

			case EOB_ACT_LAST_MATCH:
				yyg->yy_c_buf_p =
				&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[yyg->yy_n_chars];

				yy_current_state = yy_get_previous_state( yyscanner );

				yy_cp = yyg->yy_c_buf_p;
				yy_bp = yyg->yytext_ptr + YY_MORE_ADJ;
				goto yy_find_action;
			}
		break;
		}

	default:
		YY_FATAL_ERROR(
			"fatal flex scanner internal error--no action found" );
	} /* end of action switch */
		} /* end of scanning one token */
} /* end of yylex */

/* yy_get_next_buffer - try to read in a new buffer
 *
 * Returns a code representing an action:
 *	EOB_ACT_LAST_MATCH -
 *	EOB_ACT_CONTINUE_SCAN - continue scanning from current position
 *	EOB_ACT_END_OF_FILE - end of file
 */
static int yy_get_next_buffer (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
	register char *dest = YY_CURRENT_BUFFER_LVALUE->yy_ch_buf;
	register char *source = yyg->yytext_ptr;
	register int number_to_move, i;
	int ret_val;

	if ( yyg->yy_c_buf_p > &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[yyg->yy_n_chars + 1] )
		YY_FATAL_ERROR(
		"fatal flex scanner internal error--end of buffer missed" );

	if ( YY_CURRENT_BUFFER_LVALUE->yy_fill_buffer == 0 )
		{ /* Don't try to fill the buffer, so this is an EOF. */
		if ( yyg->yy_c_buf_p - yyg->yytext_ptr - YY_MORE_ADJ == 1 )
			{
			/* We matched a single character, the EOB, so
			 * treat this as a final EOF.
			 */
			return EOB_ACT_END_OF_FILE;
			}

		else
			{
			/* We matched some text prior to the EOB, first
			 * process it.
			 */
			return EOB_ACT_LAST_MATCH;
			}
		}

	/* Try to read more data. */

	/* First move last chars to start of buffer. */
	number_to_move = (int) (yyg->yy_c_buf_p - yyg->yytext_ptr) - 1;

	for ( i = 0; i < number_to_move; ++i )
		*(dest++) = *(source++);

	if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_EOF_PENDING )
		/* don't do the read, it's not guaranteed to return an EOF,
		 * just force an EOF
		 */
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = yyg->yy_n_chars = 0;

	else
		{
			int num_to_read =
			YY_CURRENT_BUFFER_LVALUE->yy_buf_size - number_to_move - 1;

		while ( num_to_read <= 0 )
			{ /* Not enough room in the buffer - grow it. */

			/* just a shorter name for the current buffer */
			YY_BUFFER_STATE b = YY_CURRENT_BUFFER;

			int yy_c_buf_p_offset =
				(int) (yyg->yy_c_buf_p - b->yy_ch_buf);

			if ( b->yy_is_our_buffer )
				{
				int new_size = b->yy_buf_size * 2;

				if ( new_size <= 0 )
					b->yy_buf_size += b->yy_buf_size / 8;
				else
					b->yy_buf_size *= 2;

				b->yy_ch_buf = (char *)
					/* Include room in for 2 EOB chars. */
					yyrealloc((void *) b->yy_ch_buf,b->yy_buf_size + 2 ,yyscanner );
				}
			else
				/* Can't grow it, we don't own it. */
				b->yy_ch_buf = 0;

			if ( ! b->yy_ch_buf )
				YY_FATAL_ERROR(
				"fatal error - scanner input buffer overflow" );

			yyg->yy_c_buf_p = &b->yy_ch_buf[yy_c_buf_p_offset];

			num_to_read = YY_CURRENT_BUFFER_LVALUE->yy_buf_size -
						number_to_move - 1;

			}

		if ( num_to_read > YY_READ_BUF_SIZE )
			num_to_read = YY_READ_BUF_SIZE;

		/* Read in more data. */
		YY_INPUT( (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
			yyg->yy_n_chars, (size_t) num_to_read );

		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = yyg->yy_n_chars;
		}

	if ( yyg->yy_n_chars == 0 )
		{
		if ( number_to_move == YY_MORE_ADJ )
			{
			ret_val = EOB_ACT_END_OF_FILE;
			yyrestart(yyin  ,yyscanner);
			}

		else
			{
			ret_val = EOB_ACT_LAST_MATCH;
			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status =
				YY_BUFFER_EOF_PENDING;
			}
		}

	else
		ret_val = EOB_ACT_CONTINUE_SCAN;

	if ((yy_size_t) (yyg->yy_n_chars + number_to_move) > YY_CURRENT_BUFFER_LVALUE->yy_buf_size) {
		/* Extend the array by 50%, plus the number we really need. */
		yy_size_t new_size = yyg->yy_n_chars + number_to_move + (yyg->yy_n_chars >> 1);
		YY_CURRENT_BUFFER_LVALUE->yy_ch_buf = (char *) yyrealloc((void *) YY_CURRENT_BUFFER_LVALUE->yy_ch_buf,new_size ,yyscanner );
		if ( ! YY_CURRENT_BUFFER_LVALUE->yy_ch_buf )
			YY_FATAL_ERROR( "out of dynamic memory in yy_get_next_buffer()" );
	}

	yyg->yy_n_chars += number_to_move;
	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[yyg->yy_n_chars] = YY_END_OF_BUFFER_CHAR;
	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[yyg->yy_n_chars + 1] = YY_END_OF_BUFFER_CHAR;

	yyg->yytext_ptr = &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[0];

	return ret_val;
}

/* yy_get_previous_state - get the state just before the EOB char was reached */

    static yy_state_type yy_get_previous_state (yyscan_t yyscanner)
{
	register yy_state_type yy_current_state;
	register char *yy_cp;
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

	yy_current_state = yy_start_state_list[yyg->yy_start];

	for ( yy_cp = yyg->yytext_ptr + YY_MORE_ADJ; yy_cp < yyg->yy_c_buf_p; ++yy_cp )
		{
		yy_current_state += yy_current_state[(*yy_cp ? YY_SC_TO_UI(*yy_cp) : 256)].yy_nxt;
		if ( yy_current_state[-1].yy_nxt )
			{
			yyg->yy_last_accepting_state = yy_current_state;
			yyg->yy_last_accepting_cpos = yy_cp;
			}
		}

	return yy_current_state;
}

/* yy_try_NUL_trans - try to make a transition on the NUL character
 *
 * synopsis
 *	next_state = yy_try_NUL_trans( current_state );
 */
    static yy_state_type yy_try_NUL_trans  (yy_state_type yy_current_state , yyscan_t yyscanner)
{
	register int yy_is_jam;
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner; /* This var may be unused depending upon options. */
	register char *yy_cp = yyg->yy_c_buf_p;

	register int yy_c = 256;
	register yyconst struct yy_trans_info *yy_trans_info;

	yy_trans_info = &yy_current_state[(unsigned int) yy_c];
	yy_current_state += yy_trans_info->yy_nxt;
	yy_is_jam = (yy_trans_info->yy_verify != yy_c);

	if ( ! yy_is_jam )
		{
		if ( yy_current_state[-1].yy_nxt )
			{
			yyg->yy_last_accepting_state = yy_current_state;
			yyg->yy_last_accepting_cpos = yy_cp;
			}
		}

	return yy_is_jam ? 0 : yy_current_state;
}

    static void yyunput (int c, register char * yy_bp , yyscan_t yyscanner)
{
	register char *yy_cp;
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

    yy_cp = yyg->yy_c_buf_p;

	/* undo effects of setting up yytext */
	*yy_cp = yyg->yy_hold_char;

	if ( yy_cp < YY_CURRENT_BUFFER_LVALUE->yy_ch_buf + 2 )
		{ /* need to shift things up to make room */
		/* +2 for EOB chars. */
		register int number_to_move = yyg->yy_n_chars + 2;
		register char *dest = &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[
					YY_CURRENT_BUFFER_LVALUE->yy_buf_size + 2];
		register char *source =
				&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move];

		while ( source > YY_CURRENT_BUFFER_LVALUE->yy_ch_buf )
			*--dest = *--source;

		yy_cp += (int) (dest - source);
		yy_bp += (int) (dest - source);
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars =
			yyg->yy_n_chars = YY_CURRENT_BUFFER_LVALUE->yy_buf_size;

		if ( yy_cp < YY_CURRENT_BUFFER_LVALUE->yy_ch_buf + 2 )
			YY_FATAL_ERROR( "flex scanner push-back overflow" );
		}

	*--yy_cp = (char) c;

	yyg->yytext_ptr = yy_bp;
	yyg->yy_hold_char = *yy_cp;
	yyg->yy_c_buf_p = yy_cp;
}

#ifndef YY_NO_INPUT
#ifdef __cplusplus
    static int yyinput (yyscan_t yyscanner)
#else
    static int input  (yyscan_t yyscanner)
#endif

{
	int c;
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

	*yyg->yy_c_buf_p = yyg->yy_hold_char;

	if ( *yyg->yy_c_buf_p == YY_END_OF_BUFFER_CHAR )
		{
		/* yy_c_buf_p now points to the character we want to return.
		 * If this occurs *before* the EOB characters, then it's a
		 * valid NUL; if not, then we've hit the end of the buffer.
		 */
		if ( yyg->yy_c_buf_p < &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[yyg->yy_n_chars] )
			/* This was really a NUL. */
			*yyg->yy_c_buf_p = '\0';

		else
			{ /* need more input */
			int offset = yyg->yy_c_buf_p - yyg->yytext_ptr;
			++yyg->yy_c_buf_p;

			switch ( yy_get_next_buffer( yyscanner ) )
				{
				case EOB_ACT_LAST_MATCH:
					/* This happens because yy_g_n_b()
					 * sees that we've accumulated a
					 * token and flags that we need to
					 * try matching the token before
					 * proceeding.  But for input(),
					 * there's no matching to consider.
					 * So convert the EOB_ACT_LAST_MATCH
					 * to EOB_ACT_END_OF_FILE.
					 */

					/* Reset buffer status. */
					yyrestart(yyin ,yyscanner);

					/*FALLTHROUGH*/

				case EOB_ACT_END_OF_FILE:
					{
					if ( yywrap(yyscanner ) )
						return EOF;

					if ( ! yyg->yy_did_buffer_switch_on_eof )
						YY_NEW_FILE;
#ifdef __cplusplus
					return yyinput(yyscanner);
#else
					return input(yyscanner);
#endif
					}

				case EOB_ACT_CONTINUE_SCAN:
					yyg->yy_c_buf_p = yyg->yytext_ptr + offset;
					break;
				}
			}
		}

	c = *(unsigned char *) yyg->yy_c_buf_p;	/* cast for 8-bit char's */
	*yyg->yy_c_buf_p = '\0';	/* preserve yytext */
	yyg->yy_hold_char = *++yyg->yy_c_buf_p;

	return c;
}
#endif	/* ifndef YY_NO_INPUT */

/** Immediately switch to a different input stream.
 * @param input_file A readable stream.
 * @param yyscanner The scanner object.
 * @note This function does not reset the start condition to @c INITIAL .
 */
    void yyrestart  (FILE * input_file , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

	if ( ! YY_CURRENT_BUFFER ){
        yyensure_buffer_stack (yyscanner);
		YY_CURRENT_BUFFER_LVALUE =
            yy_create_buffer(yyin,YY_BUF_SIZE ,yyscanner);
	}

	yy_init_buffer(YY_CURRENT_BUFFER,input_file ,yyscanner);
	yy_load_buffer_state(yyscanner );
}

/** Switch to a different input buffer.
 * @param new_buffer The new input buffer.
 * @param yyscanner The scanner object.
 */
    void yy_switch_to_buffer  (YY_BUFFER_STATE  new_buffer , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

	/* TODO. We should be able to replace this entire function body
	 * with
	 *		yypop_buffer_state();
	 *		yypush_buffer_state(new_buffer);
     */
	yyensure_buffer_stack (yyscanner);
	if ( YY_CURRENT_BUFFER == new_buffer )
		return;

	if ( YY_CURRENT_BUFFER )
		{
		/* Flush out information for old buffer. */
		*yyg->yy_c_buf_p = yyg->yy_hold_char;
		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = yyg->yy_c_buf_p;
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = yyg->yy_n_chars;
		}

	YY_CURRENT_BUFFER_LVALUE = new_buffer;
	yy_load_buffer_state(yyscanner );

	/* We don't actually know whether we did this switch during
	 * EOF (yywrap()) processing, but the only time this flag
	 * is looked at is after yywrap() is called, so it's safe
	 * to go ahead and always set it.
	 */
	yyg->yy_did_buffer_switch_on_eof = 1;
}

static void yy_load_buffer_state  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
	yyg->yy_n_chars = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
	yyg->yytext_ptr = yyg->yy_c_buf_p = YY_CURRENT_BUFFER_LVALUE->yy_buf_pos;
	yyin = YY_CURRENT_BUFFER_LVALUE->yy_input_file;
	yyg->yy_hold_char = *yyg->yy_c_buf_p;
}

/** Allocate and initialize an input buffer state.
 * @param file A readable stream.
 * @param size The character buffer size in bytes. When in doubt, use @c YY_BUF_SIZE.
 * @param yyscanner The scanner object.
 * @return the allocated buffer state.
 */
    YY_BUFFER_STATE yy_create_buffer  (FILE * file, int  size , yyscan_t yyscanner)
{
	YY_BUFFER_STATE b;
    
	b = (YY_BUFFER_STATE) yyalloc(sizeof( struct yy_buffer_state ) ,yyscanner );
	if ( ! b )
		YY_FATAL_ERROR( "out of dynamic memory in yy_create_buffer()" );

	b->yy_buf_size = size;

	/* yy_ch_buf has to be 2 characters longer than the size given because
	 * we need to put in 2 end-of-buffer characters.
	 */
	b->yy_ch_buf = (char *) yyalloc(b->yy_buf_size + 2 ,yyscanner );
	if ( ! b->yy_ch_buf )
		YY_FATAL_ERROR( "out of dynamic memory in yy_create_buffer()" );

	b->yy_is_our_buffer = 1;

	yy_init_buffer(b,file ,yyscanner);

	return b;
}

/** Destroy the buffer.
 * @param b a buffer created with yy_create_buffer()
 * @param yyscanner The scanner object.
 */
    void yy_delete_buffer (YY_BUFFER_STATE  b , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

	if ( ! b )
		return;

	if ( b == YY_CURRENT_BUFFER ) /* Not sure if we should pop here. */
		YY_CURRENT_BUFFER_LVALUE = (YY_BUFFER_STATE) 0;

	if ( b->yy_is_our_buffer )
		yyfree((void *) b->yy_ch_buf ,yyscanner );

	yyfree((void *) b ,yyscanner );
}

/* Initializes or reinitializes a buffer.
 * This function is sometimes called more than once on the same buffer,
 * such as during a yyrestart() or at EOF.
 */
    static void yy_init_buffer  (YY_BUFFER_STATE  b, FILE * file , yyscan_t yyscanner)

{
	int oerrno = errno;
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

	yy_flush_buffer(b ,yyscanner);

	b->yy_input_file = file;
	b->yy_fill_buffer = 1;

    /* If b is the current buffer, then yy_init_buffer was _probably_
     * called from yyrestart() or through yy_get_next_buffer.
     * In that case, we don't want to reset the lineno or column.
     */
    if (b != YY_CURRENT_BUFFER){
        b->yy_bs_lineno = 1;
        b->yy_bs_column = 0;
    }

        b->yy_is_interactive = 0;
    
	errno = oerrno;
}

/** Discard all buffered characters. On the next scan, YY_INPUT will be called.
 * @param b the buffer state to be flushed, usually @c YY_CURRENT_BUFFER.
 * @param yyscanner The scanner object.
 */
    void yy_flush_buffer (YY_BUFFER_STATE  b , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
	if ( ! b )
		return;

	b->yy_n_chars = 0;

	/* We always need two end-of-buffer characters.  The first causes
	 * a transition to the end-of-buffer state.  The second causes
	 * a jam in that state.
	 */
	b->yy_ch_buf[0] = YY_END_OF_BUFFER_CHAR;
	b->yy_ch_buf[1] = YY_END_OF_BUFFER_CHAR;

	b->yy_buf_pos = &b->yy_ch_buf[0];

	b->yy_at_bol = 1;
	b->yy_buffer_status = YY_BUFFER_NEW;

	if ( b == YY_CURRENT_BUFFER )
		yy_load_buffer_state(yyscanner );
}

/** Pushes the new state onto the stack. The new state becomes
 *  the current state. This function will allocate the stack
 *  if necessary.
 *  @param new_buffer The new state.
 *  @param yyscanner The scanner object.
 */
void yypush_buffer_state (YY_BUFFER_STATE new_buffer , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
	if (new_buffer == NULL)
		return;

	yyensure_buffer_stack(yyscanner);

	/* This block is copied from yy_switch_to_buffer. */
	if ( YY_CURRENT_BUFFER )
		{
		/* Flush out information for old buffer. */
		*yyg->yy_c_buf_p = yyg->yy_hold_char;
		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = yyg->yy_c_buf_p;
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = yyg->yy_n_chars;
		}

	/* Only push if top exists. Otherwise, replace top. */
	if (YY_CURRENT_BUFFER)
		yyg->yy_buffer_stack_top++;
	YY_CURRENT_BUFFER_LVALUE = new_buffer;

	/* copied from yy_switch_to_buffer. */
	yy_load_buffer_state(yyscanner );
	yyg->yy_did_buffer_switch_on_eof = 1;
}

/** Removes and deletes the top of the stack, if present.
 *  The next element becomes the new top.
 *  @param yyscanner The scanner object.
 */
void yypop_buffer_state (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
	if (!YY_CURRENT_BUFFER)
		return;

	yy_delete_buffer(YY_CURRENT_BUFFER ,yyscanner);
	YY_CURRENT_BUFFER_LVALUE = NULL;
	if (yyg->yy_buffer_stack_top > 0)
		--yyg->yy_buffer_stack_top;

	if (YY_CURRENT_BUFFER) {
		yy_load_buffer_state(yyscanner );
		yyg->yy_did_buffer_switch_on_eof = 1;
	}
}

/* Allocates the stack if it does not exist.
 *  Guarantees space for at least one push.
 */
static void yyensure_buffer_stack (yyscan_t yyscanner)
{
	int num_to_alloc;
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

	if (!yyg->yy_buffer_stack) {

		/* First allocation is just for 2 elements, since we don't know if this
		 * scanner will even need a stack. We use 2 instead of 1 to avoid an
		 * immediate realloc on the next call.
         */
		num_to_alloc = 1;
		yyg->yy_buffer_stack = (struct yy_buffer_state**)yyalloc
								(num_to_alloc * sizeof(struct yy_buffer_state*)
								, yyscanner);
		if ( ! yyg->yy_buffer_stack )
			YY_FATAL_ERROR( "out of dynamic memory in yyensure_buffer_stack()" );
								  
		memset(yyg->yy_buffer_stack, 0, num_to_alloc * sizeof(struct yy_buffer_state*));
				
		yyg->yy_buffer_stack_max = num_to_alloc;
		yyg->yy_buffer_stack_top = 0;
		return;
	}

	if (yyg->yy_buffer_stack_top >= (yyg->yy_buffer_stack_max) - 1){

		/* Increase the buffer to prepare for a possible push. */
		int grow_size = 8 /* arbitrary grow size */;

		num_to_alloc = yyg->yy_buffer_stack_max + grow_size;
		yyg->yy_buffer_stack = (struct yy_buffer_state**)yyrealloc
								(yyg->yy_buffer_stack,
								num_to_alloc * sizeof(struct yy_buffer_state*)
								, yyscanner);
		if ( ! yyg->yy_buffer_stack )
			YY_FATAL_ERROR( "out of dynamic memory in yyensure_buffer_stack()" );

		/* zero only the new slots.*/
		memset(yyg->yy_buffer_stack + yyg->yy_buffer_stack_max, 0, grow_size * sizeof(struct yy_buffer_state*));
		yyg->yy_buffer_stack_max = num_to_alloc;
	}
}

/** Setup the input buffer state to scan directly from a user-specified character buffer.
 * @param base the character buffer
 * @param size the size in bytes of the character buffer
 * @param yyscanner The scanner object.
 * @return the newly allocated buffer state object. 
 */
YY_BUFFER_STATE yy_scan_buffer  (char * base, yy_size_t  size , yyscan_t yyscanner)
{
	YY_BUFFER_STATE b;
    
	if ( size < 2 ||
	     base[size-2] != YY_END_OF_BUFFER_CHAR ||
	     base[size-1] != YY_END_OF_BUFFER_CHAR )
		/* They forgot to leave room for the EOB's. */
		return 0;

	b = (YY_BUFFER_STATE) yyalloc(sizeof( struct yy_buffer_state ) ,yyscanner );
	if ( ! b )
		YY_FATAL_ERROR( "out of dynamic memory in yy_scan_buffer()" );

	b->yy_buf_size = size - 2;	/* "- 2" to take care of EOB's */
	b->yy_buf_pos = b->yy_ch_buf = base;
	b->yy_is_our_buffer = 0;
	b->yy_input_file = 0;
	b->yy_n_chars = b->yy_buf_size;
	b->yy_is_interactive = 0;
	b->yy_at_bol = 1;
	b->yy_fill_buffer = 0;
	b->yy_buffer_status = YY_BUFFER_NEW;

	yy_switch_to_buffer(b ,yyscanner );

	return b;
}

/** Setup the input buffer state to scan a string. The next call to yylex() will
 * scan from a @e copy of @a str.
 * @param yystr a NUL-terminated string to scan
 * @param yyscanner The scanner object.
 * @return the newly allocated buffer state object.
 * @note If you want to scan bytes that may contain NUL values, then use
 *       yy_scan_bytes() instead.
 */
YY_BUFFER_STATE yy_scan_string (yyconst char * yystr , yyscan_t yyscanner)
{
    
	return yy_scan_bytes(yystr,strlen(yystr) ,yyscanner);
}

/** Setup the input buffer state to scan the given bytes. The next call to yylex() will
 * scan from a @e copy of @a bytes.
 * @param yybytes the byte buffer to scan
 * @param _yybytes_len the number of bytes in the buffer pointed to by @a bytes.
 * @param yyscanner The scanner object.
 * @return the newly allocated buffer state object.
 */
YY_BUFFER_STATE yy_scan_bytes  (yyconst char * yybytes, int  _yybytes_len , yyscan_t yyscanner)
{
	YY_BUFFER_STATE b;
	char *buf;
	yy_size_t n;
	int i;
    
	/* Get memory for full buffer, including space for trailing EOB's. */
	n = _yybytes_len + 2;
	buf = (char *) yyalloc(n ,yyscanner );
	if ( ! buf )
		YY_FATAL_ERROR( "out of dynamic memory in yy_scan_bytes()" );

	for ( i = 0; i < _yybytes_len; ++i )
		buf[i] = yybytes[i];

	buf[_yybytes_len] = buf[_yybytes_len+1] = YY_END_OF_BUFFER_CHAR;

	b = yy_scan_buffer(buf,n ,yyscanner);
	if ( ! b )
		YY_FATAL_ERROR( "bad buffer in yy_scan_bytes()" );

	/* It's okay to grow etc. this buffer, and we should throw it
	 * away when we're done.
	 */
	b->yy_is_our_buffer = 1;

	return b;
}

#ifndef YY_EXIT_FAILURE
#define YY_EXIT_FAILURE 2
#endif

static void yy_fatal_error (yyconst char* msg , yyscan_t yyscanner)
{
    	(void) fprintf( stderr, "%s\n", msg );
	exit( YY_EXIT_FAILURE );
}

/* Redefine yyless() so it works in section 3 code. */

#undef yyless
#define yyless(n) \
	do \
		{ \
		/* Undo effects of setting up yytext. */ \
        int yyless_macro_arg = (n); \
        YY_LESS_LINENO(yyless_macro_arg);\
		yytext[yyleng] = yyg->yy_hold_char; \
		yyg->yy_c_buf_p = yytext + yyless_macro_arg; \
		yyg->yy_hold_char = *yyg->yy_c_buf_p; \
		*yyg->yy_c_buf_p = '\0'; \
		yyleng = yyless_macro_arg; \
		} \
	while ( 0 )

/* Accessor  methods (get/set functions) to struct members. */

/** Get the user-defined data for this scanner.
 * @param yyscanner The scanner object.
 */
YY_EXTRA_TYPE yyget_extra  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    return yyextra;
}

/** Get the current line number.
 * @param yyscanner The scanner object.
 */
int yyget_lineno  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    
        if (! YY_CURRENT_BUFFER)
            return 0;
    
    return yylineno;
}

/** Get the current column number.
 * @param yyscanner The scanner object.
 */
int yyget_column  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    
        if (! YY_CURRENT_BUFFER)
            return 0;
    
    return yycolumn;
}

/** Get the input stream.
 * @param yyscanner The scanner object.
 */
FILE *yyget_in  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    return yyin;
}

/** Get the output stream.
 * @param yyscanner The scanner object.
 */
FILE *yyget_out  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    return yyout;
}

/** Get the length of the current token.
 * @param yyscanner The scanner object.
 */
int yyget_leng  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    return yyleng;
}

/** Get the current token.
 * @param yyscanner The scanner object.
 */

char *yyget_text  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    return yytext;
}

/** Set the user-defined data. This data is never touched by the scanner.
 * @param user_defined The data to be associated with this scanner.
 * @param yyscanner The scanner object.
 */
void yyset_extra (YY_EXTRA_TYPE  user_defined , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    yyextra = user_defined ;
}

/** Set the current line number.
 * @param line_number
 * @param yyscanner The scanner object.
 */
void yyset_lineno (int  line_number , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

        /* lineno is only valid if an input buffer exists. */
        if (! YY_CURRENT_BUFFER )
           yy_fatal_error( "yyset_lineno called with no buffer" , yyscanner); 
    
    yylineno = line_number;
}

/** Set the current column.
 * @param line_number
 * @param yyscanner The scanner object.
 */
void yyset_column (int  column_no , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

        /* column is only valid if an input buffer exists. */
        if (! YY_CURRENT_BUFFER )
           yy_fatal_error( "yyset_column called with no buffer" , yyscanner); 
    
    yycolumn = column_no;
}

/** Set the input stream. This does not discard the current
 * input buffer.
 * @param in_str A readable stream.
 * @param yyscanner The scanner object.
 * @see yy_switch_to_buffer
 */
void yyset_in (FILE *  in_str , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    yyin = in_str ;
}

void yyset_out (FILE *  out_str , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    yyout = out_str ;
}

int yyget_debug  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    return yy_flex_debug;
}

void yyset_debug (int  bdebug , yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    yy_flex_debug = bdebug ;
}

/* Accessor methods for yylval and yylloc */

/* User-visible API */

/* yylex_init is special because it creates the scanner itself, so it is
 * the ONLY reentrant function that doesn't take the scanner as the last argument.
 * That's why we explicitly handle the declaration, instead of using our macros.
 */

int yylex_init(yyscan_t* ptr_yy_globals)

{
    if (ptr_yy_globals == NULL){
        errno = EINVAL;
        return 1;
    }

    *ptr_yy_globals = (yyscan_t) yyalloc ( sizeof( struct yyguts_t ), NULL );

    if (*ptr_yy_globals == NULL){
        errno = ENOMEM;
        return 1;
    }

    /* By setting to 0xAA, we expose bugs in yy_init_globals. Leave at 0x00 for releases. */
    memset(*ptr_yy_globals,0x00,sizeof(struct yyguts_t));

    return yy_init_globals ( *ptr_yy_globals );
}

/* yylex_init_extra has the same functionality as yylex_init, but follows the
 * convention of taking the scanner as the last argument. Note however, that
 * this is a *pointer* to a scanner, as it will be allocated by this call (and
 * is the reason, too, why this function also must handle its own declaration).
 * The user defined value in the first argument will be available to yyalloc in
 * the yyextra field.
 */

int yylex_init_extra(YY_EXTRA_TYPE yy_user_defined,yyscan_t* ptr_yy_globals )

{
    struct yyguts_t dummy_yyguts;

    yyset_extra (yy_user_defined, &dummy_yyguts);

    if (ptr_yy_globals == NULL){
        errno = EINVAL;
        return 1;
    }
	
    *ptr_yy_globals = (yyscan_t) yyalloc ( sizeof( struct yyguts_t ), &dummy_yyguts );
	
    if (*ptr_yy_globals == NULL){
        errno = ENOMEM;
        return 1;
    }
    
    /* By setting to 0xAA, we expose bugs in
    yy_init_globals. Leave at 0x00 for releases. */
    memset(*ptr_yy_globals,0x00,sizeof(struct yyguts_t));
    
    yyset_extra (yy_user_defined, *ptr_yy_globals);
    
    return yy_init_globals ( *ptr_yy_globals );
}

static int yy_init_globals (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
    /* Initialization is the same as for the non-reentrant scanner.
     * This function is called from yylex_destroy(), so don't allocate here.
     */

    yyg->yy_buffer_stack = 0;
    yyg->yy_buffer_stack_top = 0;
    yyg->yy_buffer_stack_max = 0;
    yyg->yy_c_buf_p = (char *) 0;
    yyg->yy_init = 0;
    yyg->yy_start = 0;

    yyg->yy_start_stack_ptr = 0;
    yyg->yy_start_stack_depth = 0;
    yyg->yy_start_stack =  NULL;

/* Defined in main.c */
#ifdef YY_STDINIT
    yyin = stdin;
    yyout = stdout;
#else
    yyin = (FILE *) 0;
    yyout = (FILE *) 0;
#endif

    /* For future reference: Set errno on error, since we are called by
     * yylex_init()
     */
    return 0;
}

/* yylex_destroy is for both reentrant and non-reentrant scanners. */
int yylex_destroy  (yyscan_t yyscanner)
{
    struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;

    /* Pop the buffer stack, destroying each element. */
	while(YY_CURRENT_BUFFER){
		yy_delete_buffer(YY_CURRENT_BUFFER ,yyscanner );
		YY_CURRENT_BUFFER_LVALUE = NULL;
		yypop_buffer_state(yyscanner);
	}

	/* Destroy the stack itself. */
	yyfree(yyg->yy_buffer_stack ,yyscanner);
	yyg->yy_buffer_stack = NULL;

    /* Destroy the start condition stack. */
        yyfree(yyg->yy_start_stack ,yyscanner );
        yyg->yy_start_stack = NULL;

    /* Reset the globals. This is important in a non-reentrant scanner so the next time
     * yylex() is called, initialization will occur. */
    yy_init_globals( yyscanner);

    /* Destroy the main struct (reentrant only). */
    yyfree ( yyscanner , yyscanner );
    yyscanner = NULL;
    return 0;
}

/*
 * Internal utility routines.
 */

#ifndef yytext_ptr
static void yy_flex_strncpy (char* s1, yyconst char * s2, int n , yyscan_t yyscanner)
{
	register int i;
	for ( i = 0; i < n; ++i )
		s1[i] = s2[i];
}
#endif

#ifdef YY_NEED_STRLEN
static int yy_flex_strlen (yyconst char * s , yyscan_t yyscanner)
{
	register int n;
	for ( n = 0; s[n]; ++n )
		;

	return n;
}
#endif

#define YYTABLES_NAME "yytables"

/*-----------------------------------------------------------------------------
*   Token
*----------------------------------------------------------------------------*/
DEF_CLASS(Token);
DEF_CLASS_LIST(Token);

void Token_init( Token *self ) 
{
    /* force init strpool to make sure Context is destroyed before StrPool */
    strpool_init();

	self->str_value = OBJ_NEW(Str);
	OBJ_AUTODELETE( self->str_value ) = FALSE;
}

void Token_copy( Token *self, Token *other )
{
	self->str_value = Str_clone( other->str_value );
}

void Token_fini( Token *self ) 
{ 
	OBJ_DELETE( self->str_value );
}

/* set a token by copy of another */
void Token_set( Token *self, Token *other )
{
	self->tok_type	= other->tok_type;
	self->num_value	= other->num_value;
	
	Str_set( self->str_value, other->str_value );
	
	self->filename	= other->filename;	/* point to same strpool area */
	self->line_nr	= other->line_nr;
}

/* clear a token */
void Token_clear( Token *self )
{
	self->tok_type	= TOK_NULL;
	self->num_value	= 0;
	
	Str_clear( self->str_value );
	
	self->filename	= NULL;
	self->line_nr	= 0;
}

/*-----------------------------------------------------------------------------
*   Stack of nested constructs
*----------------------------------------------------------------------------*/
DEF_CLASS(Struct);
DEF_CLASS_LIST(Struct);

void Struct_init( Struct *self ) { }

void Struct_copy( Struct *self, Struct *other ) { }

void Struct_fini( Struct *self ) { }

/* push start of new struct to stack, fatal error if no context */
void scan_push_struct( int id, int value )
{
	Context	*context;
	Struct  *elem;
	
	init_scan();
	
	context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		elem = OBJ_NEW( Struct );
		elem->id 		= id;
		elem->value 	= value;
		elem->line_nr	= context->line_nr;
		
		StructList_push( context->struct_stack, elem );
	}
}

static Struct *scan_top( void )
{
	Context	*context;

	init_scan();
	
	context = get_context();
	if ( context == NULL || StructList_empty( context->struct_stack ) )
	{
		error( ERR_UNBALANCED_STRUCT );
		return NULL;
	}
	else
	{
		return StructList_last( context->struct_stack )->obj;
	}
}

/* return ID of top of struct stack, -1 if none */
int scan_top_id( void )						
{
	Struct *elem = scan_top();
	return elem ? elem->id : -1;
}

/* return VALUE of top of struct stack, -1 if none */
int scan_top_value( void )
{
	Struct *elem = scan_top();
	return elem ? elem->value : -1;
}

/* replace ID, VALUE of top element, e.g replace IF by ELSE */
void scan_replace_struct( int id, int value )
{
	Context	*context;
	Struct  *elem;
	
	init_scan();
	
	context = get_context();
	if ( context == NULL )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		elem = scan_top();
		elem->id 		= id;
		elem->value 	= value;
		elem->line_nr	= context->line_nr;
	}
}

/* pop top element, syntaxt error if id != top_id */
void scan_pop_struct( int id )
{
	Context	*context;
	Struct  *elem;
	
	init_scan();
	
	context = get_context();
	if ( context == NULL || StructList_empty( context->struct_stack ) )
	{
		error( ERR_UNBALANCED_STRUCT );
	}
	else 
	{
		elem = StructList_pop( context->struct_stack );
		if ( elem->id != id ) 
		{
			error( ERR_UNBALANCED_STRUCT_AT, 
				   elem->line_nr );
		}
		
		OBJ_DELETE( elem );	
	}
}

/*-----------------------------------------------------------------------------
*   Scanner context - current input file/buffer
*----------------------------------------------------------------------------*/
DEF_CLASS(Context);
DEF_CLASS_LIST(Context);

void Context_init( Context *self )	/* only init non-null items */
{
    /* force init strpool to make sure Context is destroyed before StrPool */
    strpool_init();
	
	self->struct_stack = OBJ_NEW( StructList );
	OBJ_AUTODELETE( self->struct_stack ) = FALSE;
}

void Context_copy( Context *self, Context *other ) { }

void Context_fini( Context *self )	/* free resources */
{
	if ( self->scanner ) {
		yylex_destroy(self->scanner );
	}
	
	if ( self->file )
	{
		fclose( self->file );
	}
	
	OBJ_DELETE( self->struct_stack );
}

/* create a new context and switch yylex to its buffer */
Context *Context_create( FILE *file, char *filename, int line_nr, int line_inc )
{
	Context *self;

	/* allocate and init new context */
	self = OBJ_NEW(Context);
	self->file		= file;
	self->filename	= strpool_add(filename);
	self->line_nr	= line_nr;
	self->line_inc	= line_inc;
	
	/* init a new scanner */
	yylex_init_extra(self,&self->scanner );
	
	/* interface with errors */
	set_error_null();
	set_error_file( filename );   			/* error location */
	
	return self;
}

/* return current context */
static Context *get_context( void )
{
	init_scan();
	
	if ( ContextList_empty( scan->contexts ) )
		return NULL;
	else
		return ContextList_last( scan->contexts )->obj;
}

/* pop the stack of input files, return TRUE to continue reading, FALSE on end */
static BOOL pop_context( void ) 
{
	Context *context;
	
	init_scan();
	
	/* interface with errors */
	set_error_null();

	context = ContextList_pop( scan->contexts );
	if ( context == NULL )
	{
		return FALSE;					/* no more input */
	}
	else 
	{
		/* destroy context */
		OBJ_DELETE( context );
		
		/* switch to previous context, if any */
		context = get_context();
		if ( context == NULL )
		{
			return FALSE;				/* no more input */
		}
		else 
		{
			/* interface with errors */
			set_error_file( context->filename );
			set_error_line( context->line_nr );

			return TRUE;				/* continue scanning */
		}
	}
}

/*-----------------------------------------------------------------------------
*	Scanner global data
*----------------------------------------------------------------------------*/
DEF_CLASS(Scan);

void Scan_init( Scan *self ) 
{
    /* force init strpool to make sure Context is destroyed before StrPool */
    strpool_init();

	self->contexts = OBJ_NEW( ContextList );
	OBJ_AUTODELETE( self->contexts ) = FALSE;
	
	self->token_queue = OBJ_NEW( TokenList );
	OBJ_AUTODELETE( self->token_queue ) = FALSE;
	
	self->token = OBJ_NEW( Token );
	OBJ_AUTODELETE( self->token ) = FALSE;
}

void Scan_copy( Scan *self, Scan *other ) { }

void Scan_fini( Scan *self ) 
{ 
	OBJ_DELETE( self->contexts );
	OBJ_DELETE( self->token_queue );
	OBJ_DELETE( self->token );
}

/*-----------------------------------------------------------------------------
*   Get / Unget token
*----------------------------------------------------------------------------*/

/* scan input for next token, set scan->token with last token value */
TokType scan_get( void )
{
	Context	*context;
	Token 	*token;
	Struct  *elem;

	init_scan();

	/* init scan->token */
	Token_clear( scan->token );
	
	/* get token from queue */
	token = TokenList_pop( scan->token_queue );
	if ( token != NULL )
	{
		Token_set( scan->token, token );
		OBJ_DELETE( token );
	}
	else
	{
		/* loop until input ended for all existing contexts, or token found */
		while ( (context = get_context()) != NULL )
		{
			if ( ( scan->token->tok_type = yylex(context->scanner ) ) != TOK_NULL )
			{
				break;					/* found input */
			}
			
			/* check for open structs */
			while ( (elem = StructList_pop( context->struct_stack )) != NULL )
			{
				error( ERR_UNBALANCED_STRUCT_AT, 
					   elem->line_nr );
				OBJ_DELETE( elem );
			}
			
			pop_context();				/* pop top context, clear error location */
		}
	}
	
	return scan->token->tok_type;
}

/* unget the given token to the list */
void scan_unget( TokType tok_type, long num_value, char *str_value,
				 char *filename, int line_nr )
{
	Token *token;

	init_scan();
	
	/* init token object */
	token = OBJ_NEW(Token);
	token->tok_type		= tok_type;
	token->num_value	= num_value;
	
	Str_szset( token->str_value, str_value ? str_value : "" );	/* copy string */
	Str_unreserve( token->str_value );			/* reclaim extra memory for queue */
	
	token->filename 	= strpool_add( filename );
	token->line_nr		= line_nr;
	
	/* set last token */
	Token_set( scan->token, token );
	
	TokenList_push( scan->token_queue, token );
}

/*-----------------------------------------------------------------------------
*   Get last token
*----------------------------------------------------------------------------*/
TokType scan_tok_type( void )
{
	init_scan();
	return scan->token->tok_type;
}

long scan_num_value( void )
{
	init_scan();
	return scan->token->num_value;
}

char *scan_str_value( void )
{
	init_scan();
	return Str_data( scan->token->str_value );
}

char *scan_filename( void )
{
	init_scan();
	return scan->token->filename;
}

int scan_line_nr( void )
{
	init_scan();
	return scan->token->line_nr;
}

/*-----------------------------------------------------------------------------
*	Context stack
*----------------------------------------------------------------------------*/

/* check circular includes, error if found */
static void check_circular_includes( char *filename ) 
{
	ContextListElem *iter;
	
	for ( iter = ContextList_first( scan->contexts ) ; iter != NULL ; 
		  iter = ContextList_next( iter ) )
	{
		if ( iter->obj->file != NULL &&			/* open file, not scanned text */
		     strcmp( filename, iter->obj->filename ) == 0 )
		{
            fatal_error( ERR_INCLUDE_RECURSION, filename );
		}
	}
}	

/* create a context to scan a file */
void scan_file( char *filename ) 
{
	FILE 	*file;
	Context	*context;
	
	init_scan();
	
	/* search source path */
	filename = search_source_file( filename );
	
	/* check for circular includes */
	check_circular_includes( filename );
	
	/* try to open the file */
	file = fopen( filename, "rb" ); 		/* b: to ready \r and \n */
	if ( file == NULL ) 
	{
		fatal_error( ERR_FOPEN_READ, filename );
	}

	/* create new flex instance */
	context = Context_create( file, filename, 1, 1 );
	ContextList_push( scan->contexts, context );
	
	/* set input file */
	yyset_in(file,context->scanner );
	
	/* prepare for list */
	if ( listing )
	{
		context->do_list = TRUE;
	}
}

/* create a context to scan a text block */
void scan_text( char *text )
{
	Context 	   *context, *prev_context;
	char 		   *prev_filename;
	int 			prev_line_nr;
	
	init_scan();
	
	/* if already reading input, copy file and line_nr of last item in stack */
	prev_context = get_context();
	prev_filename = prev_context != NULL ? prev_context->filename : NULL;
	prev_line_nr  = prev_context != NULL ? prev_context->line_nr  : 0;

	/* create new flex instance */
	context = Context_create( NULL, prev_filename, prev_line_nr, 0 );
	ContextList_push( scan->contexts, context );
	
	/* switch to text buffer */
	yy_scan_string(text,context->scanner );
}

/*-----------------------------------------------------------------------------
*	convert number to long, range error if greater than LONG_MAX
*----------------------------------------------------------------------------*/
static long scan_num (char *text, int num_suffix_chars, int base)
{
	long value;
	int digit;
	int length;
	char c;
	int i;
	
	/* ignore any suffix characters */
	length = strlen(text) - num_suffix_chars;
	
	value = 0;
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
			error( ERR_SYNTAX );
		}

		if (digit >= base) {			/* digit out of range - should not be reached */
			error( ERR_SYNTAX );
		}
		
		value = value * base + digit;
	}
	
	return value;
}

/*-----------------------------------------------------------------------------
*   Memory allocation used in scanner
*----------------------------------------------------------------------------*/
void *yyalloc(size_t bytes,yyscan_t scanner )
{
    return xmalloc( bytes );
}

void *yyrealloc(void *ptr,size_t bytes,yyscan_t scanner )
{
    return xrealloc( ptr, bytes );
}

void yyfree(void *ptr,yyscan_t scanner )
{
    xfree( ptr );
}

