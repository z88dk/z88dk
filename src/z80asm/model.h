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

Global data model.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/model.h,v 1.26 2014-09-11 22:28:35 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "list.h"
#include "module.h"
#include "types.h"

/*-----------------------------------------------------------------------------
*   Symbol type bitmasks - bits 3 to 6 same as Expression type bitmasks
*----------------------------------------------------------------------------*/
#define SYM_DEFINED		1       	/* 00000001 symbol is defined */
#define SYM_TOUCHED		2       	/* 00000010 symbol was used, e.g. returned by 
									   a symbol table search */

#define SYM_TYPE		120     	/* 01111000 */

#define SYM_LOCAL		16      	/* 00010000 symbol is local */
#define SYM_PUBLIC		32      	/* 00100000 symbol is PUBLIC */
#define SYM_EXTERN		64      	/* 01000000 symbol is EXTERN */

#define SYM_NOTDEFINED  0

/*-----------------------------------------------------------------------------
*   Expression expr_type_mask bitmasks - bits 3 to 6 same as Symbol type bitmasks
*----------------------------------------------------------------------------*/
#define EXPR_LOCAL		SYM_LOCAL  	/* 00010000 Expression contains local symbol */
#define EXPR_PUBLIC		SYM_PUBLIC 	/* 00100000 Expression contains global symbol */
#define EXPR_EXTERN		SYM_EXTERN	/* 01000000 Expression contains extern symbol */

/*-----------------------------------------------------------------------------
*   Special symbols
*----------------------------------------------------------------------------*/
#define ASMHEAD_KW	"ASMHEAD%s%s"
#define ASMTAIL_KW	"ASMTAIL%s%s"
#define ASMSIZE_KW	"ASMSIZE%s%s"

/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
extern void model_init(void);

/*-----------------------------------------------------------------------------
*   Singleton interfaces
*----------------------------------------------------------------------------*/

/* interface to SrcFile singleton */
extern void  src_open( char *filename, List *dir_list );
extern char *src_getline( void );
extern void  src_ungetline( char *lines );
extern char *src_filename( void );
extern int   src_line_nr( void );	

extern void  src_push( void );
extern Bool  src_pop( void );
