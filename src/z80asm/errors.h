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
Copyright (C) Paulo Custodio, 2011
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.h,v 1.1 2011-07-12 22:47:59 pauloscustodio Exp $ */
/* $Log: errors.h,v $
/* Revision 1.1  2011-07-12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* */

#ifndef ERRORS_H
#define ERRORS_H

#include "symbol.h"

/* errnum constants */
enum {
    ERR_NO_ERR			= -1,
    ERR_FILE_OPEN		= 0,
    ERR_SYNTAX			= 1,
    ERR_NOT_DEFINED		= 2,
    ERR_NO_MEMORY		= 3,
    ERR_INT_RANGE		= 4,
    ERR_EXPR_SYNTAX		= 5,
    ERR_UNBALANCED_PAREN	= 6,
    ERR_RANGE			= 7,
    ERR_NO_SRC_FILE		= 8,
    ERR_ILLEGAL_OPTION		= 9,
    ERR_UNKNOWN_IDENT		= 10,
    ERR_ILLEGAL_IDENT		= 11,
    ERR_MAX_CODESIZE		= 12,
    ERR_TOTALERRORS		= 13,
    ERR_SYMBOL_REDEFINED	= 14,
    ERR_MODULE_REDEFINED	= 15,
    ERR_MODULE_NOT_DEFINED	= 16,   /* not used */
    ERR_SYMBOL_DECL_LOCAL	= 17,
    ERR_SYMBOL_DECL_GLOBAL	= 18,
    ERR_SYMBOL_DECL_EXTERN	= 19,   /* not used */
    ERR_NO_CMD_ARGS		= 20,   /* not used */
    ERR_ILLEGAL_SRC_FILE	= 21,
    ERR_SYMBOL_REDECL_GLOBAL	= 22,
    ERR_SYMBOL_REDECL		= 23,
    ERR_ORG_REDEFINED		= 24,	/* not used */
    ERR_JR_NOT_LOCAL		= 25,
    ERR_NOT_OBJ_FILE		= 26,
    ERR_RESERVED_NAME		= 27,	/* not used */
    ERR_OPEN_LIB		= 28,
    ERR_NOT_LIB_FILE		= 29,
    ERR_ENV_NOT_DEFINED		= 30,
    ERR_INCLUDE_RECURSION	= 31,
};


/* global error variables */
extern enum flag ASMERROR;
extern int ASSEMBLE_ERROR, ERRORS, TOTALERRORS;

/* reset error status */
extern void ResetErrors (void);

/* report error functions */
extern void ReportError   (char *filename, int linenr, int errnum);
extern void ReportIOError (char *filename);

#endif /* ndef ERRORS_H */
