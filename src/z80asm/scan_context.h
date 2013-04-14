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

Scanner context - current input file/buffer

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/scan_context.h,v 1.1 2013-04-14 18:16:59 pauloscustodio Exp $
$Log: scan_context.h,v $
Revision 1.1  2013-04-14 18:16:59  pauloscustodio
Split scanner in several modules, allow token look-ahead to simplify
parser.


*/

#ifndef SCAN_CONTEXT_H
#define SCAN_CONTEXT_H

#include "memalloc.h"	/* before any other include */

#include "class.h"
#include "classlist.h"
#include "scan_struct.h"
#include "scan_token.h"
#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Scanner context
*----------------------------------------------------------------------------*/

typedef void* yyscan_t;			/* forward declaration */

/* Scanner context - current input file/buffer */
CLASS(Context)
	yyscan_t	scanner;		/* current scanner object */

	FILE   *file; 				/* file handle */
	char   *filename;			/* file name - kept in strpool so that it is 
								   available after file has been closed */
	int 	line_nr;			/* input line number */
	int 	line_inc;			/* increment line number on each newline */
	
	BOOL	do_list;			/* true to output list lines */
	BOOL	first_time;			/* true before first token is retrieved */

	StructList *struct_stack;	/* stack of open structs, empty if none */
	
	TokenRing *tokens;			/* look-ahead ring of tokens */

END_CLASS;

/* Scanner context - scack of contexts, top of stack is current */
CLASS_LIST(Context);

/* create a new context and switch yylex to its buffer */
extern Context *Context_create( FILE *file, char *filename, int line_nr, int line_inc );

#endif /* ndef SCAN_CONTEXT_H */
