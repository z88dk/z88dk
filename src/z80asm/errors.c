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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.c,v 1.6 2011-10-14 14:46:03 pauloscustodio Exp $ */
/* $Log: errors.c,v $
/* Revision 1.6  2011-10-14 14:46:03  pauloscustodio
/* -  BUG_0013 : defm check for MAX_CODESIZE incorrect
/*  - Remove un-necessary tests for MAX_CODESIZE; all tests are concentrated in check_space() from codearea.c.
/*
/* Revision 1.5  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions xfputc, xfgetc, ... to raise the exception on error.
/*
/* Revision 1.4  2011/08/14 19:27:52  pauloscustodio
/* - ReportError() raises the new exception FatalErrorException for fatal error ERR_MAX_CODESIZE
/*
/* Revision 1.3  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.2  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.1  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* */

#include "memalloc.h"	/* before any other include to enable memory leak detection */

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include "errors.h"
#include "options.h"
#include "z80asm.h"
#include "config.h"

/* global variables */
int	    ASSEMBLE_ERROR  = ERR_NO_ERR;   /* > ERR_NO_ERR if error */
enum flag   ASMERROR	    = OFF;	    /* ON if error */
int	    ERRORS	    = 0;	    /* num errors in current source */
int	    TOTALERRORS	    = 0;	    /* total num errors */

/* static variables */
static char *errmsg[] = {
    /* 0  */    "File '%s' open error",		
    /* 1  */    "Syntax error",			
    /* 2  */    "Symbol not defined",			
    /* 3  */    "Not enough memory",			
    /* 4  */    "Integer '%ld' out of range",		
    /* 5  */    "Syntax error in expression",		
    /* 6  */    "Unbalanced parenthesis",		
    /* 7  */    "Out of range",			
    /* 8  */    "Source filename missing",		
    /* 9  */    "Illegal option '-%s'",			
    /* 10 */    "Unknown identifier",			
    /* 11 */    "Illegal identifier",			
    /* 12 */    "Max. code size of %ld bytes reached",	
    /* 13 */    "%d errors occurred during assembly",	
    /* 14 */    "Symbol '%s' already defined",		
    /* 15 */    "Module name already defined",		
    /* 16 */    "Module name not defined",		
    /* 17 */    "Symbol '%s' already declared local",	
    /* 18 */    "Symbol '%s' already declared global",	
    /* 19 */    "Symbol '%s' already declared external",	
    /* 20 */    "No command line arguments",		
    /* 21 */    "Illegal source filename '%s'",		
    /* 22 */    "Symbol '%s' declared global in another module",	
    /* 23 */    "Re-declaration of '%s' not allowed",	
    /* 24 */    "ORG already defined",		
    /* 25 */    "Relative jump address must be local",		
    /* 26 */    "File '%s' not an object file",		
    /* 27 */    "Reserved name",		
    /* 28 */    "Couldn't open library file '%s'",	
    /* 29 */    "File '%s' not a library file",		
    /* 30 */    "Environment variable '%s' not defined",	
    /* 31 */    "Cannot include file '%s' recursively",	
    /* 32 */	"File I/O error",
};

/*-----------------------------------------------------------------------------
*   ResetErrors
*	Reset global error variables to no-error
*----------------------------------------------------------------------------*/
void ResetErrors (void)
{
    ASMERROR	    = OFF;
    ASSEMBLE_ERROR  = ERR_NO_ERR;
    ERRORS	    = 0;
    TOTALERRORS	    = 0;
}

/*-----------------------------------------------------------------------------
*   ReportError
*	Report error errnum at given file and line number
*----------------------------------------------------------------------------*/
void ReportError (char *filename, int lineno, int errnum, ...)
{
    va_list argptr;
    char errstr[MAXLINE], *p;
    
    va_start(argptr, errnum);	/* init variable args */
  
    ASSEMBLE_ERROR = errnum;	/* set the global error variable for general error trapping */
    ASMERROR = ON;
 
    if (clinemode && clineno) 
	lineno = clineno;

    /* CH_0003 : output prefix */
    p = errstr;
    p += sprintf(p, "Error: ");

    /* output filename */
    if (filename != NULL)
	p += sprintf(p, "File '%s', ", filename);

    /* output module */
    if (CURRENTMODULE != NULL && CURRENTMODULE->mname != NULL)
	p += sprintf(p, "Module '%s', ", CURRENTMODULE->mname);

    /* output line number */
    if (lineno != 0)
	p += sprintf(p, "at line %d, ", lineno);

    /* handle special errors */
    if (errnum >= 0 && errnum < NUM_ELEMS(errmsg)) {
	switch (errnum) {
	    case ERR_MAX_CODESIZE:
		p += sprintf(p, errmsg[errnum], (long)MAXCODESIZE);
		break;

	    case ERR_TOTALERRORS:
		/* ignore all the info collected in errstr */
		p = errstr;
		p += sprintf(p, errmsg[errnum], TOTALERRORS);
		break;

	    default:
		p += vsprintf(p, errmsg[errnum], argptr);	/* pass variable args */
	 }
    }
    else {
	p += sprintf(p, "Error %d", errnum);
    }

    /* add newline */
    p += sprintf(p, "\n");
    assert(p - errstr < sizeof(errstr) - 1);    /* check for overrun */

    /* CH_0001 : Assembly error messages should appear on stderr */  
    fputs(errstr, stderr);
    if (errfile != NULL)
	fputs(errstr, errfile);

    /* increment error counters */
    ++ERRORS;
    ++TOTALERRORS;
}

