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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/errors.c,v 1.1 2011-07-12 22:47:59 pauloscustodio Exp $ */
/* $Log: errors.c,v $
/* Revision 1.1  2011-07-12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* */

#include <stdio.h>
#include <string.h>
#include "errors.h"
#include "options.h"
#include "z80asm.h"
#include "config.h"

/* global error variables */
enum flag ASMERROR;
int ASSEMBLE_ERROR, ERRORS, TOTALERRORS;

/* module variables */
static char *errmsg[] = {
    /* 0  */    "File open/read error",		
    /* 1  */    "Syntax error",			
    /* 2  */    "Symbol not defined",			
    /* 3  */    "Not enough memory",			
    /* 4  */    "Integer out of range",		
    /* 5  */    "Syntax error in expression",		
    /* 6  */    "Right bracket missing",		
    /* 7  */    "Out of range",			
    /* 8  */    "Source filename missing",		
    /* 9  */    "Illegal option",			
    /* 10 */    "Unknown identifier",			
    /* 11 */    "Illegal identifier",			
    /* 12 */    "Max. code size of %ld bytes reached",	
    /* 13 */    "errors occurred during assembly",	
    /* 14 */    "Symbol already defined",		
    /* 15 */    "Module name already defined",		
    /* 16 */    "Module name not defined",		
    /* 17 */    "Symbol already declared local",	
    /* 18 */    "Symbol already declared global",	
    /* 19 */    "Symbol already declared external",	
    /* 20 */    "No command line arguments",		
    /* 21 */    "Illegal source filename",		
    /* 22 */    "Symbol declared global in another module",	
    /* 23 */    "Re-declaration not allowed",	
    /* 24 */    "ORG already defined",		
    /* 25 */    "Relative jump address must be local",		
    /* 26 */    "Not an object file",		
    /* 27 */    "Reserved name",		
    /* 28 */    "Couldn't open library file",	
    /* 29 */    "Not a library file",		
    /* 30 */    "Environment variable not defined",	
    /* 31 */    "Cannot include file recursively",	
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
void ReportError (char *filename, int lineno, int errnum)
{
  char	errstr[256], errflnmstr[128], errmodstr[128], errlinestr[64];
  

  ASSEMBLE_ERROR = errnum;	/* set the global error variable for general error trapping */
  ASMERROR = ON;
 
  errflnmstr[0] = '\0';
  errmodstr[0] = '\0'; 
  errlinestr[0] = '\0';
  errstr[0] = '\0';


  if (clinemode && clineno ) lineno=clineno;

  if (filename != NULL)
    sprintf (errflnmstr,"File '%s', ", filename);

  if (CURRENTMODULE != NULL)
    if ( CURRENTMODULE->mname != NULL )
      sprintf(errmodstr,"Module '%s', ", CURRENTMODULE->mname);

  if (lineno != 0)
    sprintf (errlinestr, "at line %d, ", lineno);
     
  strcpy(errstr, errflnmstr);
  strcat(errstr, errmodstr);
  strcat(errstr, errlinestr);
  strcat(errstr, errmsg[errnum]);
 
  /* CH_0001 : Assembly error messages should appear on stderr */  
  switch(errnum)
    {
      case 12:
          fprintf (stderr, errstr, MAXCODESIZE);
          fputc ('\n',stderr);
	  if (errfile != NULL) { 
          fprintf (errfile, errstr, MAXCODESIZE);
          fputc ('\n',errfile);
        }
        break;

      case 13:
        fprintf (stderr, "%d %s\n", TOTALERRORS, errmsg[errnum]);
        break;

      default:
          fprintf (stderr, "%s\n", errstr);
	  if (errfile != NULL) 
	  fprintf (errfile, "%s\n", errstr);
     }

  ++ERRORS;
  ++TOTALERRORS;
}

/*-----------------------------------------------------------------------------
*   ReportIOError
*	Report file IO error for given file
*----------------------------------------------------------------------------*/
void ReportIOError (char *filename)
{
  ASSEMBLE_ERROR = ERR_FILE_OPEN;
  ASMERROR = ON;

  if (CURRENTMODULE != NULL)
    if ( CURRENTMODULE->mname != NULL )
       fprintf(stderr,"Module '%s', ", CURRENTMODULE->mname);
  fprintf (stderr,"file '%s' couldn't be opened or created\n", filename);

  ++ERRORS;
  ++TOTALERRORS;
}

