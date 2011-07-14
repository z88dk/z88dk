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
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/asmdrctv.c,v 1.17 2011-07-14 01:32:08 pauloscustodio Exp $ */
/* $Log: asmdrctv.c,v $
/* Revision 1.17  2011-07-14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.16  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.15  2011/07/11 15:56:46  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/*
/* Revision 1.14  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.13  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.12  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.11  2011/07/09 01:14:13  pauloscustodio
/* added casts to clean up warnings
/* 
/* Revision 1.10  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/* 
/* Revision 1.9  2009/08/14 22:23:12  dom
/* clean up some compiler warnings
/* 
/* Revision 1.8  2009/06/22 21:26:28  dom
/* don't expand a zero length file
/* 
/* Revision 1.7  2009/06/13 17:36:24  dom
/* Add -I and -L to specify search paths for libraries and includes
/* 
/* Revision 1.6  2003/10/11 15:41:04  dom
/* changes from garry
/* 
/* - support for defp -> defp addr,bank
/* - square brackets can be used in expressions
/* - comma can be used in defm
/* 
/* Revision 1.5  2002/02/20 21:37:57  dom
/* merged in changes from rc1.4 branch to handle empty lines in list files
/* 
/* Revision 1.4  2001/06/27 08:53:28  dom
/* branches:  1.4.2;
/* Added a second parameter to defs to indicate what the filler byte should be
/* 
/* Revision 1.3  2001/02/28 17:59:22  dom
/* Added UNDEFINE for undefining symbols, bumped version to 1.0.18
/* 
/* Revision 1.2  2001/01/23 10:00:08  dom
/* Changes by x1cygnus:
/* 
/* just added a harcoded macro Invoke, similar to callpkg except that the
/* instruction 'Invoke' resolves to a call by default (ti83) and to a RST if
/* the parameter -plus is specified on the command line.
/* 
/* Changes by dom:
/* Added in a rudimentary default directory set up (Defined at compile time)
/* a bit kludgy and not very nice!
/* 
/* Revision 1.1  2000/07/04 15:33:30  dom
/* branches:  1.1.1;
/* Initial revision
/* 
/* Revision 1.1.1.1  2000/07/04 15:33:30  dom
/* First import of z88dk into the sourceforge system <gulp>
/* 
/* Revision 1.4.2.1  2002/02/20 21:35:19  dom
/* changes from dennis to handle blank lines in file list files
/* 
/* */

/* $History: Asmdrctv.c $ */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:04 */
/* Updated in $/Z80asm */
/* MAXCODESIZE checking implemented for DEFB, DEFW, DEFL & DEFM. */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:27 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 0:57 */
/* Updated in $/Z80asm */
/* Redundant system include files removed. */
/* Binary() rewritten to replace low I/O open() with fopen(), fread(). */
/* Fetchfilename() now doesn't changed parsed filename due to UNIX OS. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:01 */
/* Updated in $/Z80asm */
/* IncludeFile() now validates for recursive including of identical files. */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 3  ***************** */
/* User: Gbs          Date: 4-09-98    Time: 0:08 */
/* Updated in $/Z80asm */
/* DEFVARS functionality extended with -1 argument. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:21 */
/* Updated in $/Z80asm */
/* Version History Comment block syntax layout corrected. */

/*  */
/* *****************  Version 1  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 14:52 */
/* Created in $/Z80asm */
/* Improvements on defm() and Fetchfilename(): */
/* fgetc() logic now handled better according to EOF events. */

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include "config.h"
#include "options.h"
#include "symbol.h"
#include "z80asm.h"
#include "errors.h"

/* external functions */
enum symbols GetSym (void);
int DefineSymbol (char *identifier, long value, unsigned char symboltype);
int ExprSigned8 (int listoffset);
int ExprUnsigned8 (int listoffset);
int ExprAddress (int listoffset);
int ExprLong (int listoffset);
int DefineDefSym (char *identifier, long value, unsigned char symtype, avltree ** root);
int DEFSP (void);
int GetChar (FILE *fptr);
char *AllocIdentifier (size_t len);
long EvalPfixExpr (struct expr *pfixexpr);
long GetConstant (char *evalerr);
void Pass2info (struct expr *expression, char constrange, long lfileptr);
void RemovePfixlist (struct expr *pfixexpr);
void Z80pass1 (void);
void Skipline (FILE *fptr);
struct expr *ParseNumExpr (void);
struct sourcefile *Newfile (struct sourcefile *curfile, char *fname);
struct sourcefile *Prevfile (void);
struct sourcefile *FindFile (struct sourcefile *srcfile, char *fname);
int cmpidstr (symbol * kptr, symbol * p);
void FreeSym (symbol * node);
symbol *FindSymbol (char *identifier, avltree * treeptr);


/* local functions */
void DeclModuleName (void);
void DefSym (void);
void UnDefineSym (void);


/* global variables */
extern FILE *z80asmfile, *listfile;
extern unsigned char *codeptr, *codearea;
extern char ident[], stringconst[];
extern unsigned short DEFVPC;
extern long PC;
extern enum symbols sym;
extern enum flag writeline, EOL;
extern struct modules *modulehdr;
extern struct module *CURRENTMODULE;
extern int sourcefile_open;


int 
DEFSP (void)
{
  if (GetSym () == fullstop)
    if (GetSym () == name)
      switch (ident[0])
	{
	case 'B':
	  return 1;

	case 'W':
	  return 2;

	case 'P':
	  return 3;

	case 'L':
	  return 4;

	default:
	  return -1;
	}
    else
      {
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	return -1;
      }
  else
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      return -1;
    }
}



long 
Parsevarsize (void)
{

  struct expr *postfixexpr;

  long offset = 0, varsize, size_multiplier;

  if (strcmp (ident, "DS") != 0)
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
  else
    {
      if ((varsize = DEFSP ()) == -1)
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_UNKNOWN_IDENT);
      else
	{
	  GetSym ();

	  if ((postfixexpr = ParseNumExpr ()) != NULL)
	    {
	      if (postfixexpr->rangetype & NOTEVALUABLE)
		{
		  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
		  RemovePfixlist (postfixexpr);
		}
	      else
		{
		  size_multiplier = EvalPfixExpr (postfixexpr);
		  RemovePfixlist (postfixexpr);
		  if (size_multiplier > 0 && size_multiplier <= MAXCODESIZE)
		    offset = varsize * size_multiplier;
		  else
		    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE, size_multiplier);
		}
	    }
	}
    }

  return offset;
}



long 
Parsedefvarsize (long offset)
{
  long varoffset = 0;

  switch (sym)
    {
    case name:
      if (strcmp (ident, "DS") != 0)
	{
	  DefineSymbol (ident, offset, 0);
	  GetSym ();
	}
      if (sym == name)
	  varoffset = Parsevarsize ();
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
    }

  return varoffset;
}



void 
DEFVARS (void)
{
  struct expr *postfixexpr;

  long offset;
  enum flag globaldefv;

  writeline = OFF;		/* DEFVARS definitions are not output'ed to listing file */
  GetSym ();

  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {				/* expr. must not be stored in relocatable file */
      if (postfixexpr->rangetype & NOTEVALUABLE)
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
	  RemovePfixlist (postfixexpr);
	  return;
	}
      else
	{
	  offset = EvalPfixExpr (postfixexpr);	/* offset expression must not contain undefined symbols */
	  RemovePfixlist (postfixexpr);
	}

      if ((offset != -1) && (offset != 0))
	{
          DEFVPC = (unsigned short)offset;
	  globaldefv = ON;
	}
      else
	{
	  if (offset == -1)
	    {
	      globaldefv = ON;
	      offset = DEFVPC;
	    }
	  else
	    {
	      /* offset = 0, use temporarily without smashing DEFVPC */
	      globaldefv = OFF;
	    }
	}
    }
  else
    return;			/* syntax error raised in ParseNumExpr() - get next line from file... */

  while (!feof (z80asmfile) && sym != lcurly)
    {
      Skipline (z80asmfile);

      EOL = OFF;
      ++CURRENTFILE->line;
      GetSym ();
    }

  if (sym == lcurly)
    {
      while (!feof (z80asmfile) && GetSym () != rcurly)
	{
	  if (EOL == ON)
	    {
	      ++CURRENTFILE->line;
	      EOL = OFF;
	    }
	  else
	    offset += Parsedefvarsize (offset);
	}

      if (globaldefv == ON)
	{
          DEFVPC = (unsigned short)offset;
	}
    }
}



void 
DEFGROUP (void)
{
  struct expr *postfixexpr;
  long constant, enumconst = 0;

  writeline = OFF;		/* DEFGROUP definitions are not output'ed to listing file */

  while (!feof (z80asmfile) && GetSym () != lcurly)
    {
      Skipline (z80asmfile);
      EOL = OFF;
      ++CURRENTFILE->line;
    }

  if (sym == lcurly)
    {
      while (!feof (z80asmfile) && sym != rcurly)
	{
	  if (EOL == ON)
	    {
	      ++CURRENTFILE->line;
	      EOL = OFF;
	    }
	  else
	    {
	      do
		{
		  GetSym ();
		  switch (sym)
		    {
		    case rcurly:
		    case semicolon:
		    case newline:
		      break;

		    case name:
		      strcpy (stringconst, ident);	/* remember name */
		      if (GetSym () == assign)
			{
			  GetSym ();

			  if ((postfixexpr = ParseNumExpr ()) != NULL)
			    {
			      if (postfixexpr->rangetype & NOTEVALUABLE)
				ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
			      else
				{
				  constant = EvalPfixExpr (postfixexpr);
				  enumconst = constant;
				  DefineSymbol (stringconst, enumconst++, 0);
				}
			      RemovePfixlist (postfixexpr);
			    }
			  GetSym ();	/* prepare for next identifier */
			}
		      else
			DefineSymbol (stringconst, enumconst++, 0);
		      break;

		    default:
		      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
		      break;
		    }
		}
	      while (sym == comma);	/* get enum definitions separated by comma in current line */

	      Skipline (z80asmfile);	/* ignore rest of line */
	    }
	}
    }
}


void 
DEFS ()
{
  struct expr *postfixexpr;
  struct expr *constexpr;

  long constant,val;

  GetSym ();			/* get numerical expression */
  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {				/* expr. must not be stored in relocatable file */
      if (postfixexpr->rangetype & NOTEVALUABLE)
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
      else
	{
	  constant = EvalPfixExpr (postfixexpr);

	  if ( sym != comma ) 
	    {
		val = 0;
	    }
	  else 
	    {
		GetSym();
		if ( (constexpr = ParseNumExpr ()) != NULL ) 
		  {
		    if ( constexpr->rangetype & NOTEVALUABLE )
			ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
		    else
			val = EvalPfixExpr(constexpr);
		    RemovePfixlist(constexpr);
		  }
	    }
	  if (constant >= 0)
	    {
	      if ((PC + constant) <= MAXCODESIZE)
		{
		  PC += constant;

                  while (constant--) *codeptr++ = (unsigned char)val;
		}
	      else
		{
		  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);
		  return;
		}
	    }
	  else
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE, constant);
	      return;
	    }
	}
      RemovePfixlist (postfixexpr);	/* remove linked list, expression evaluated */
    }
}

void 
UnDefineSym(void)
{
   symbol *sym;

  do
    {
      if (GetSym () == name)
	sym = FindSymbol(ident,CURRENTMODULE->localroot);
	if ( sym != NULL ) {
                delete (&CURRENTMODULE->localroot, sym, (int (*)(void*,void*)) cmpidstr, (void (*)(void*)) FreeSym);
	}
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;
	}
    }
  while (GetSym () == comma);
}

void 
DefSym (void)
{
  do
    {
      if (GetSym () == name)
	DefineDefSym (ident, 1, 0, &CURRENTMODULE->localroot);
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;
	}
    }
  while (GetSym () == comma);
}


void 
DEFC (void)
{
  struct expr *postfixexpr;
  long constant;

  do
    {
      if (GetSym () == name)
	{
	  strcpy (stringconst, ident);	/* remember name */

	  if (GetSym () == assign)
	    {
	      GetSym ();	/* get numerical expression */
	      if ((postfixexpr = ParseNumExpr ()) != NULL)
		{		/* expr. must not be stored in
				   * relocatable file */
		  if (postfixexpr->rangetype & NOTEVALUABLE)
		    {
		      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
		      break;
		    }
		  else
		    {
		      constant = EvalPfixExpr (postfixexpr);	/* DEFC expression must not
								 * contain undefined symbols */
		      DefineSymbol (stringconst, constant, 0);
		    }
		  RemovePfixlist (postfixexpr);
		}
	      else
		break;		/* syntax error - get next line from file... */
	    }
	  else
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	      break;
	    }
	}
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;
	}
    }
  while (sym == comma);		/* get all DEFC definition separated by comma */
}



void 
ORG (void)
{

  struct expr *postfixexpr;
  long constant;

  GetSym ();			/* get numerical expression */

  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      if (postfixexpr->rangetype & NOTEVALUABLE)
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
      else
	{
	  constant = EvalPfixExpr (postfixexpr);	/* ORG expression must not contain undefined symbols */
	  if (constant >= 0 && constant <= 65535U)
	    CURRENTMODULE->origin = constant;
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE, constant);
	}
      RemovePfixlist (postfixexpr);
    }
}


void 
DEFB (void)
{
  long bytepos = 0;

  do
    {
      if ((PC+1) > MAXCODESIZE) 
        {
           ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);
           return;
        }

      GetSym ();
      if (!ExprUnsigned8 (bytepos))
	break;			/* syntax error - get next line from file... */
      ++PC;			/* DEFB allocated, update assembler PC */
      ++bytepos;

      if (sym == newline)
	break;
      else if (sym != comma)
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;
	}
    }
  while (sym == comma);		/* get all DEFB definitions separated by comma */
}



void 
DEFW (void)
{
  long bytepos = 0;

  do
    {
      if ((PC+2) > MAXCODESIZE) 
        {
           ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);
           return;
        }

      GetSym ();
      if (!ExprAddress (bytepos))
	break;			/* syntax error - get next line from file... */
      PC += 2;			/* DEFW allocated, update assembler PC */
      bytepos += 2;

      if (sym == newline)
	break;
      else if (sym != comma)
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;
	}
    }
  while (sym == comma);		/* get all DEFB definitions separated by comma */
}



void 
DEFP (void)
{
  long bytepos = 0;

  do
    {
      if ((PC+3) > MAXCODESIZE) 
        {
           ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);
           return;
        }

      GetSym ();
      if (!ExprAddress (bytepos))
	break;			/* syntax error - get next line from file... */
      PC += 2;			/* DEFW allocated, update assembler PC */
      bytepos += 2;

		/* Pointers must be specified as WORD,BYTE pairs separated by commas */ 
		if (sym != comma)
		{
			ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
		}

      GetSym ();
      if (!ExprUnsigned8 (bytepos))
	break;			/* syntax error - get next line from file... */
      PC += 1;			/* DEFB allocated, update assembler PC */
      bytepos += 1;

      if (sym == newline)
	break;
      else if (sym != comma)
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;
	}
    }
  while (sym == comma);		/* get all DEFB definitions separated by comma */
}



void 
DEFL (void)
{
  long bytepos = 0;

  do
    {
      if ((PC+4) > MAXCODESIZE) 
        {
           ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);
           return;
        }

      GetSym ();
      if (!ExprLong (bytepos))
	break;			/* syntax error - get next line from file... */
      PC += 4;			/* DEFL allocated, update assembler PC */
      bytepos += 4;

      if (sym == newline)
	break;
      else if (sym != comma)
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;
	}
    }
  while (sym == comma);		/* get all DEFB definitions separated by comma */
}




void 
DEFM (void)
{
  long constant, bytepos = 0;

  do
    {
      if (GetSym () == dquote)
	{
	  while (!feof (z80asmfile))
	    {
              if ((PC+1) > MAXCODESIZE) 
                {
                  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);
                  return;
                }

	      constant = GetChar (z80asmfile);
	      if (constant == EOF)
		{
		  sym = newline;
		  EOL = ON;
		  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
		  return;
		}
	      else
		{
		  if (constant != '\"')
		    {
                      *codeptr++ = (unsigned char)constant;
		      ++bytepos;
		      ++PC;
		    }
		  else
		    {
		      GetSym ();

		      if (sym != strconq && sym != comma && sym != newline && sym != semicolon)
			{
			  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
			  return;
			}
		      break;	/* get out of loop */
		    }
		}
	    }
	}
      else
	{ 
          if ((PC+1) > MAXCODESIZE) 
            {
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);
              return;
            }

	  if (!ExprUnsigned8 (bytepos))
	    break;		/* syntax error - get next line from file... */

	  if (sym != strconq && sym != comma && sym != newline && sym != semicolon)
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);	/* expression separator not found */
	      break;
	    }
	  ++bytepos;
	  ++PC;
	}
    }
  while (sym != newline && sym != semicolon);
}




void 
IncludeFile (void)
{
  char    *filename;

  if (GetSym () == dquote)
    {				/* fetch filename of include file */
      filename = Fetchfilename (z80asmfile);

      if (FindFile(CURRENTFILE,filename) != NULL)
        {
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INCLUDE_RECURSION, filename);
          return; 
        }

      CURRENTFILE->filepointer = ftell (z80asmfile);	/* get file position of current source file */
      fclose (z80asmfile);	/* close current source file */

      if ((z80asmfile = fopen (filename, "rb")) == NULL)
        {			/* Open include file */
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_FILE_OPEN, filename);
          z80asmfile = fopen (CURRENTFILE->fname, "rb");		/* re-open current source file */
          fseek (z80asmfile, CURRENTFILE->filepointer, SEEK_SET);	/* file position to beginning of line
                                                                     * following INCLUDE line */
          return;
        }
      else
        {
          sourcefile_open = 1;
          CURRENTFILE = Newfile (CURRENTFILE, filename);	/* Allocate new file into file information list */

          if (ASSEMBLE_ERROR == ERR_NO_MEMORY)
            return;		/* No room... */
          if (verbose)
            puts (CURRENTFILE->fname);	/* display name of INCLUDE file */

          Z80pass1 ();		/* parse include file */

          CURRENTFILE = Prevfile ();	/* Now get back to current file... */

          switch (ASSEMBLE_ERROR)
            {
            case ERR_FILE_OPEN:
            case ERR_NO_MEMORY:
            case ERR_MAX_CODESIZE:
              return;		/* Fatal errors, return immediatly... */
            }

          sourcefile_open = fclose (z80asmfile);

          if ((z80asmfile = fopen (CURRENTFILE->fname, "rb")) == NULL)
            {			/* re-open current source file */
              ReportError(NULL, 0, ERR_FILE_OPEN, CURRENTFILE->fname);
            }
          else
            {
              fseek (z80asmfile, CURRENTFILE->filepointer, 0);	/* file position to beginning of */
              sourcefile_open = 1;
            }
        }			/* line following INCLUDE line */
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);

  sym = newline;
  writeline = OFF;		/* don't write current source line to listing file (empty line of INCLUDE file) */
}


void 
BINARY (void)
{
  char      *filename;
  FILE		*binfile;
  long		Codesize;

  if (GetSym () == dquote)
    {
      filename = Fetchfilename (z80asmfile);

      if ((binfile = fopen (filename, "rb")) == NULL)
        {
          ReportError (NULL, 0, ERR_FILE_OPEN, filename);
          return;
        }
		
	  fseek(binfile, 0L, SEEK_END);	/* file pointer to end of file */
	  Codesize = ftell(binfile);
	  fseek(binfile, 0L, SEEK_SET);	/* file pointer to start of file */
	  
	  if ((codeptr - codearea + Codesize) <= MAXCODESIZE)
	    {
          fread (codeptr, sizeof (char), Codesize, binfile);	/* read binary code */
          codeptr += Codesize;							/* codeptr updated */
	      PC += Codesize;
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MAX_CODESIZE);

	  fclose (binfile);
	}
  else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
}



char * 
Fetchfilename (FILE *fptr)
{
  char  *ptr;
  int    l, c = 0;

  do {
    for (l = 0;l<255; l++) 
      {
        if (!feof (fptr)) 
          {
            c = GetChar (fptr);
            if ((c == '\n') || (c == EOF))
              break;

            if (c != '"') 
              {
                ident[l] = (char) c;
              } 
            else 
              {
                break;       /* fatal - end of file reached! */
              }
          } 
        else 
          {
	        break;
          }
      }
    ident[l] = '\0';		/* null-terminate file name */
  } while (strlen(ident) == 0 && !feof(fptr) );
	
  if (c != '\n') Skipline (fptr); /* prepare for next line */
  ptr = ident;
  if ( *ptr =='#' ) {
    ptr++;
  }

  return strlen(ptr) ? SearchFile(ptr, 1) : "";
}



void 
DeclModuleName (void)
{
  if (CURRENTMODULE->mname == NULL)
    {
      if (sym == name)
	{
	  if ((CURRENTMODULE->mname = AllocIdentifier (strlen (ident) + 1)) != NULL)
	    strcpy (CURRENTMODULE->mname, ident);
	  else
	    ReportError (NULL, 0, ERR_NO_MEMORY);
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_MODULE_REDEFINED);
}


/*
 * Local Variables:
 *  indent-tabs-mode:nil
 *  require-final-newline:t
 *  c-basic-offset: 2
 *  eval: (c-set-offset 'case-label 0)
 *  eval: (c-set-offset 'substatement-open 2)
 *  eval: (c-set-offset 'access-label 0)
 *  eval: (c-set-offset 'class-open 2)
 *  eval: (c-set-offset 'class-close 2)
 * End:
 */

