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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80pass.c,v 1.19 2011-08-19 15:53:58 pauloscustodio Exp $ */
/* $Log: z80pass.c,v $
/* Revision 1.19  2011-08-19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* Revision 1.18  2011/08/19 10:20:32  pauloscustodio
/* - Factored code to read/write word from file into xfget_word/xfput_word.
/* - Renamed ReadLong/WriteLong to xfget_long/xfput_long for symetry.
/*
/* Revision 1.17  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions xfputc, xfgetc, ... to raise the exception on error.
/*
/* Revision 1.16  2011/08/14 19:37:43  pauloscustodio
/* Z80pass1(): no need to check for fatal error and return; bypassed by exception mechanism
/*
/* Revision 1.15  2011/08/05 20:20:45  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
/* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
/* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
/* removing all the test code after each memory allocation.
/* Replaced all functions that allocated memory structures by the new xcalloc_struct().
/* Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
/* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
/* Created try/catch sequences to clean-up partially created memory structures and rethrow the
/* exception, to cleanup memory leaks.
/* Replaced 'l' (lower case letter L) by 'len' - too easy to confuse with numeral '1'.
/*
/* Revision 1.14  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.13  2011/07/14 01:32:08  pauloscustodio
/*     - Unified "Integer out of range" and "Out of range" errors; they are the same error.
/*     - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
/*     CH_0003 : Error messages should be more informative
/*         - Added printf-args to error messages, added "Error:" prefix.
/*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
/*         - Raise ERR_UNBALANCED_PAREN instead
/*
/* Revision 1.12  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.11  2011/07/11 16:19:37  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/* Created declarations in z80asm.h of objects defined in z80asm.c.
/*
/* Revision 1.10  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.9  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.8  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/* 
/* Revision 1.7  2011/07/09 01:34:12  pauloscustodio
/* added casts to clean up warnings
/* BUG_0004 : 8bit unsigned constants are not checked for out-of-range
/*      Added the check to ExprUnsigned8() and Z80pass2().
/* 
/* Revision 1.6  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/* 
/* Revision 1.5  2009/09/03 17:54:55  dom
/* Fix name conflict with the getline function in POSIX 2008
/* 
/* Nabbed via Fedora/Kevin Kofler
/* 
/* Revision 1.4  2009/08/14 22:23:12  dom
/* clean up some compiler warnings
/* 
/* Revision 1.3  2002/05/11 20:09:38  dom
/* A patch around the appalling IF ELSE ENDIF handling of z80asm where it
/* tries to evaluate FALSE clauses and gets completely in a twist.
/* 
/* These patches turn off the output to the two errors that I've seen pop
/* up in this state: Syntax error and unknown identifier. Please test this
/* one quite hard if you get a change... - it was done to allow even more
/* complicated logic in the z88 app startup to actually work - as soon as I'm
/* happy with that I'll commit it as well
/* 
/* Revision 1.2  2001/03/21 16:34:01  dom
/* Added changes to allow labels to end in ':' and the prefix '.' isn't
/* necessarily needed..this isn't guaranteed to be perfect so let me know
/* of any problems and drop back to 1.0.18
/* 
/* Revision 1.1  2000/07/04 15:33:29  dom
/* branches:  1.1.1;
/* Initial revision
/* 
/* Revision 1.1.1.1  2000/07/04 15:33:29  dom
/* First import of z88dk into the sourceforge system <gulp>
/* 
/* */

/* $History: Z80PASS.C $ */
/*  */
/* *****************  Version 14  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 12  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:39 */
/* Updated in $/Z80asm */
/* parseline() bug fix: code size may reach <= MAXCODESIZE. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 30-05-99   Time: 1:06 */
/* Updated in $/Z80asm */
/* New function, Flncmp() to compare two filenames after internal lower */
/* case conversion (used by Include file mutual recursion validation). */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:16 */
/* Updated in $/Z80asm */
/* New function, FindFile(), to validate whether an include file already */
/* has been included in a previous include level. */
/* Z80pass2() bug fix: Expressions that are saved to object file */
/* (typically containing external symbols) shouldn't get evaluated - this */
/* can create unnecessary error messages. */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */

#include "memalloc.h"	/* before any other include to enable memory leak detection */

#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include "config.h"
#include "symbol.h"
#include "hist.h"
#include "options.h"
#include "z80asm.h"
#include "errors.h"
#include "file.h"
#include "codearea.h"

/* external functions */
void Skipline (FILE *fptr);
void LinkModules (void);
void DefineOrigin (void);
void ParseIdent (enum flag interpret);
void RemovePfixlist (struct expr *pfixexpr);
void StoreExpr (struct expr *pfixexpr, char range);
int DefineSymbol (char *identifier, long value, unsigned char symboltype);
int GetChar(FILE *fptr);
long EvalPfixExpr (struct expr *pass2expr);
struct expr *ParseNumExpr (void);
enum symbols GetSym (void);
symbol *FindSymbol (char *identifier, avltree * treeptr);

/* local functions */
void ifstatement (enum flag interpret);
void parseline (enum flag interpret);
void getasmline (void);
void Pass2info (struct expr *expression, char constrange, long lfileptr);
void Z80pass1 (void);
void Z80pass2 (void);
void WriteSymbolTable (char *msg, avltree * root);
void WriteListFile (void);
void WriteHeader (void);
void LineCounter (void);
void PatchListFile (struct expr *pass2expr, long c);
void WriteMapFile (void);
void StoreName (symbol * node, unsigned char symscope);
void StoreLibReference (symbol * node);
void StoreGlobalName (symbol * node);
void StoreLocalName (symbol * node);
long Evallogexpr (void);
struct sourcefile *Prevfile (void);
struct sourcefile *Newfile (struct sourcefile *curfile, char *fname);
struct sourcefile *Setfile (struct sourcefile *curfile, struct sourcefile *newfile, char *fname);
struct sourcefile *FindFile (struct sourcefile *srcfile, char *fname);


/* global variables */
extern FILE *z80asmfile, *listfile, *objfile, *mapfile;
extern char *date, line[], ident[], separators[];
extern char *lstfilename, *objfilename, objext[], binext[];
extern enum symbols sym;
extern enum flag writeline, EOL;
extern unsigned char PAGELEN;
extern long listfileptr, TOTALLINES;
extern struct modules *modulehdr;	/* pointer to module header */
extern struct module *CURRENTMODULE;
extern int PAGENR, LINENR;
extern avltree *globalroot;

void 
Z80pass1 (void)
{
  line[0] = '\0';		    /* reset contents of list buffer */

  while (!feof (z80asmfile))
    {
      if (listing)
	writeline = ON;
      parseline (ON);		    /* before parsing it */
    }
}



void 
getasmline (void)
{
  long fptr;
  int len,c;

  fptr = ftell (z80asmfile);		/* remember file position */

  c = '\0';
  for (len=0; (len<254) && (c!='\n'); len++) 
    {
      c = GetChar(z80asmfile); 
      if (c != EOF)
        line[len] = c;	/* line feed inclusive */
      else
        break;
    }
  line[len] = '\0'; 

  fseek (z80asmfile, fptr, SEEK_SET);	/* resume file position */
}



void 
parseline (enum flag interpret)
{
  FindSymbol (ASSEMBLERPC, globalroot)->symvalue = get_PC();	/* update assembler program counter */

  if (get_PC() <= MAXCODESIZE)
    {				/* room for z80 machine code? */
      ++CURRENTFILE->line;
      ++TOTALLINES;
      if (listing)
	getasmline ();		/* get a copy of current source line */

      EOL = OFF;		/* reset END OF LINE flag */
      GetSym ();
      if (sym == fullstop || sym == label)
	{
	  if (interpret == ON)
	    {			/* Generate only possible label declaration if line parsing is allowed */
	      if (sym == label || GetSym () == name)
		{
		  DefineSymbol (ident, get_PC(), SYMADDR | SYMTOUCHED);	/* labels must always be
									 * touched due to forward */
		  	GetSym ();	/* check for another identifier *//* referencing problems in
				   * expressions */
		}
	      else
		{
		  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);	/* a name must follow a
										 * label declaration */
		  return;	/* read in a new source line */
		}
	    }
	  else
	    {
	      Skipline (z80asmfile);
	      sym = newline;	/* ignore label and rest of line */
	    }
	}
      switch (sym)
	{
	case name:
	  ParseIdent (interpret);
	  break;

	case newline:
	  break;		/* empty line, get next... */

	default:
	    if ( interpret == ON )
	       ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);	/* Syntax error */
	}

      if (listing && writeline)
	WriteListFile ();	/* Write current source line to list file, if allowed */
    }
  else
    ReportError (NULL, 0, ERR_MAX_CODESIZE);	/* no more room in machine code area */
}



/* multilevel contitional assembly logic */

void 
ifstatement (enum flag interpret)
{
  if (interpret == ON)
    {				/* evaluate #if expression */
      if (Evallogexpr () != 0)
	{

	  do
	    {			/* expression is TRUE, interpret lines until #else or #endif */
	      if (!feof (z80asmfile))
		{
		  writeline = ON;
		  parseline (ON);
		}
	      else
		return;		/* end of file - exit from this #if level */
	    }
	  while ((sym != elsestatm) && (sym != endifstatm));

	  if (sym == elsestatm)
	    {
	      do
		{		/* then ignore lines until #endif ... */
		  if (!feof (z80asmfile))
		    {
		      writeline = OFF;
		      parseline (OFF);
		    }
		  else
		    return;
		}
	      while (sym != endifstatm);
	    }
	}
      else
	{
	  do
	    {			/* expression is FALSE, ignore until #else or #endif */
	      if (!feof (z80asmfile))
		{
		  writeline = OFF;
		  parseline (OFF);
		}
	      else
		return;
	    }
	  while ((sym != elsestatm) && (sym != endifstatm));

	  if (sym == elsestatm)
	    {
	      do
		{
		  if (!feof (z80asmfile))
		    {
		      writeline = ON;
		      parseline (ON);
		    }
		  else
		    return;
		}
	      while (sym != endifstatm);
	    }
	}
    }
  else
    {
      do
	{			/* don't evaluate #if expression and ignore all lines until #endif */
	  if (!feof (z80asmfile))
	    {
	      writeline = OFF;
	      parseline (OFF);
	    }
	  else
	    return;		/* end of file - exit from this IF level */
	}
      while (sym != endifstatm);
    }

  sym = nil;
}



long 
Evallogexpr (void)
{
  struct expr *postfixexpr;
  long constant = 0;

  GetSym ();			/* get logical expression */
  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      constant = EvalPfixExpr (postfixexpr);
      RemovePfixlist (postfixexpr);	/* remove linked list, expression evaluated */
    }
  return constant;
}




void 
Z80pass2 (void)
{
  struct expr *pass2expr, *prevexpr;
  struct JRPC *curJR, *prevJR;
  long constant;
  long fptr_exprdecl, fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
  size_t patchptr;


  if ((pass2expr = CURRENTMODULE->mexpr->firstexpr) != NULL)
    {
      curJR = CURRENTMODULE->JRaddr->firstref;	/* point at first JR PC address in this module */
      do
	{
	  constant = EvalPfixExpr (pass2expr);
	  if (pass2expr->stored == OFF)
	    {
	      if ((pass2expr->rangetype & EXPREXTERN) || (pass2expr->rangetype & EXPRADDR))
		{
		  /*
		   * Expression contains symbol declared as external or defined as a relocatable
		   * address,
		   */
		  /* store expression in relocatable file */
		  switch (pass2expr->rangetype & RANGE)
		    {
		    case RANGE_32SIGN:
		      StoreExpr (pass2expr, 'L');
		      break;

		    case RANGE_16CONST:
		      StoreExpr (pass2expr, 'C');
		      break;

		    case RANGE_8UNSIGN:
		      StoreExpr (pass2expr, 'U');
		      break;

		    case RANGE_8SIGN:
		      StoreExpr (pass2expr, 'S');
		      break;
		    }
		}
	    }
	  if ((pass2expr->rangetype & NOTEVALUABLE) && (pass2expr->stored==OFF))
	    {
	      if ((pass2expr->rangetype & RANGE) == RANGE_JROFFSET)
		{
		  if (pass2expr->rangetype & EXPREXTERN)
		    ReportError (pass2expr->srcfile, pass2expr->curline, ERR_JR_NOT_LOCAL);	/* JR, DJNZ used an
										 * external label - */
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, ERR_NOT_DEFINED);
		  prevJR = curJR;
		  curJR = curJR->nextref;	/* get ready for next JR instruction */
		  xfree0(prevJR);
		}
	      else
		ReportError (pass2expr->srcfile, pass2expr->curline, ERR_NOT_DEFINED);
	    }
	  else
	    {
	      patchptr = pass2expr->codepos;		/* index in memory buffer */
	      switch (pass2expr->rangetype & RANGE)
		{
		case RANGE_JROFFSET:
		  constant -= curJR->PCaddr;	/* get module PC at JR instruction */
		  if (constant >= -128 && constant <= 127)
		    {
		      patch_byte(&patchptr, (unsigned char) constant);	
					   /* opcode is stored, now store relative jump */
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant);
		  prevJR = curJR;
		  curJR = curJR->nextref;	/* get ready for JR instruction */
		  xfree0(prevJR);
		  break;

		case RANGE_8UNSIGN:
                    /* BUG_0004 add test Integer out of range error */
                    if (constant >= -128 && constant <= 255) {
			patch_byte(&patchptr, (unsigned char) constant);	
					   /* opcode is stored, now store byte */
                    }
                    else {
                        ReportError (pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant);
                    }
		  break;

		case RANGE_8SIGN:
		  if (constant >= -128 && constant <= 255)
		    {
		      patch_byte(&patchptr, (unsigned char) constant);	
					   /* opcode is stored, now store signed operand */
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant);
		  break;

		case RANGE_16CONST:
		  if (constant >= -32768 && constant <= 65535)
		    {
		      patch_word(&patchptr, (int) constant);	
					   /* store two bytes */
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant);
		  break;

		case RANGE_32SIGN:
		  if (constant >= LONG_MIN && constant <= LONG_MAX)
		    {
		      patch_long(&patchptr, constant);	
					   /* store 4 bytes */
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, ERR_INT_RANGE, constant);
		  break;
		}
	    }

	  if (listing_CPY)
	    PatchListFile (pass2expr, constant);

	  prevexpr = pass2expr;
	  pass2expr = pass2expr->nextexpr;	/* get next pass2 expression */
	  RemovePfixlist (prevexpr);	/* release current expression */
	}
      while (pass2expr != NULL);	/* re-evaluate expressions and patch in code */

      xfree0(CURRENTMODULE->mexpr);	/* Release header of expressions list */
      xfree0(CURRENTMODULE->JRaddr);	/* Release header of relative jump address list */
      CURRENTMODULE->mexpr = NULL;
      CURRENTMODULE->JRaddr = NULL;
    }
  if ((TOTALERRORS == 0) && symtable)
    {
      WriteSymbolTable ("Local Module Symbols:", CURRENTMODULE->localroot);
      WriteSymbolTable ("Global Module Symbols:", globalroot);
    }
  fptr_namedecl = ftell (objfile);
  inorder (CURRENTMODULE->localroot, (void (*)(void*)) StoreLocalName); /* Store Local Name declarations to relocatable file */
  inorder (globalroot, (void (*)(void*)) StoreGlobalName);      /* Store Global name declarations to relocatable file */

  fptr_libnmdecl = ftell (objfile);	/* Store library reference names */
  inorder (globalroot, (void (*)(void*)) StoreLibReference);    /* Store library reference name declarations to relocatable file */

  fptr_modname = ftell (objfile);
  constant = strlen (CURRENTMODULE->mname);
  xfputc(constant, objfile);	/* write length of module name to relocatable file */
  xfwritec(CURRENTMODULE->mname, (size_t) constant, objfile);	/* write module name to relocatable
										 * file       */
  if ((constant = get_code_size()) == 0)
    fptr_modcode = -1;		/* no code generated!  */
  else
    {
      fptr_modcode = ftell (objfile);
      xfput_word(constant, objfile);	/* two bytes of module code size */
      fwrite_codearea(objfile);
    }

  if (verbose)
    printf ("Size of module is %ld bytes\n", constant);

  fseek (objfile, 8, SEEK_SET);	/* set file pointer to point at ORG */
  if ((modulehdr->first == CURRENTMODULE))
    {
      if (deforigin)
	CURRENTMODULE->origin = EXPLICIT_ORIGIN;	/* use origin from command line */
    }
  xfput_word(CURRENTMODULE->origin, objfile);		/* two bytes of origin */

  fptr_exprdecl = 30;		/* expressions always begins at file position 24 */

  if (fptr_namedecl == fptr_exprdecl)
    fptr_exprdecl = -1;		/* no expressions */
  if (fptr_libnmdecl == fptr_namedecl)
    fptr_namedecl = -1;		/* no name declarations */
  if (fptr_modname == fptr_libnmdecl)
    fptr_libnmdecl = -1;	/* no library reference declarations */

  xfput_long(fptr_modname, objfile);	/* write fptr. to module name */
  xfput_long(fptr_exprdecl, objfile);	/* write fptr. to name declarations */
  xfput_long(fptr_namedecl, objfile);	/* write fptr. to name declarations */
  xfput_long(fptr_libnmdecl, objfile);	/* write fptr. to library name declarations */
  xfput_long(fptr_modcode, objfile);	/* write fptr. to module code */
}


void 
StoreGlobalName (symbol * node)
{
  if ((node->type & SYMXDEF) && (node->type & SYMTOUCHED))
    StoreName (node, SYMXDEF);
}


void 
StoreLocalName (symbol * node)
{
  if ((node->type & SYMLOCAL) && (node->type & SYMTOUCHED))
    StoreName (node, SYMLOCAL);
}


void 
StoreName (symbol * node, unsigned char scope)
{
  int b;

  switch (scope)
    {
    case SYMLOCAL:
      xfputc('L', objfile);
      break;

    case SYMXDEF:
      if (node->type & SYMDEF)
	xfputc('X', objfile);
      else
	xfputc('G', objfile);
      break;
    }
  if (node->type & SYMADDR)	/* then write type of symbol */
    xfputc('A', objfile);	/* either a relocatable address */
  else
    xfputc('C', objfile);	/* or a constant */

  xfput_long(node->symvalue, objfile);

  b = strlen (node->symname);
  xfputc(b, objfile);		/* write length of symbol name to relocatable file */
  xfwritec(node->symname, (size_t) b, objfile);	/* write symbol name to relocatable file */
}


void 
StoreLibReference (symbol * node)
{
  size_t b;

  if ((node->type & SYMXREF) && (node->type & SYMDEF) && (node->type & SYMTOUCHED))
    {
      b = strlen (node->symname);
      xfputc((int) b, objfile);	/* write length of symbol name to relocatable file */
      xfwritec(node->symname, b, objfile);	/* write symbol name to relocatable file */
    }
}


void 
Pass2info (struct expr *pfixexpr,	/* pointer to header of postfix expression linked list */
	   char constrange,	/* allowed size of value to be parsed */
	   long byteoffset)
{				/* position in listing file to patch */



  if (listing)
    byteoffset = listfileptr + 12 + 3 * byteoffset + 6 * ((byteoffset) / 32);
  /*
   * |    |   |  |   | add extra line, if hex bytes more than 1 line start of      |   |  | no. of hex bytes
   * rel. to start current line in    |   length of hex number + space listfile      | linenumber & 2 spaces +
   * hex address and 2 spaces
   */
  else
    byteoffset = -1;		/* indicate that this expression is not going to be patched in listing file */


  pfixexpr->nextexpr = NULL;
  pfixexpr->rangetype = constrange;
  pfixexpr->srcfile = CURRENTFILE->fname;	/* pointer to record containing current source file name */
  pfixexpr->curline = CURRENTFILE->line;	/* pointer to record containing current line number */
  pfixexpr->listpos = byteoffset;	/* now calculated as absolute file pointer */

  if (CURRENTMODULE->mexpr->firstexpr == NULL)
    {
      CURRENTMODULE->mexpr->firstexpr = pfixexpr;
      CURRENTMODULE->mexpr->currexpr = pfixexpr;	/* Expression header points at first expression */
    }
  else
    {
      CURRENTMODULE->mexpr->currexpr->nextexpr = pfixexpr;	/* Current expr. node points to new expression
								 * node */
      CURRENTMODULE->mexpr->currexpr = pfixexpr;	/* Pointer to current expr. node updated */
    }
}



struct sourcefile *
Prevfile (void)
{
  struct usedfile *newusedfile;
  struct sourcefile *ownedfile;

  newusedfile = xcalloc_struct(struct usedfile);
  ownedfile = CURRENTFILE;
  CURRENTFILE = CURRENTFILE->prevsourcefile;	/* get back to owner file - now the current */
  CURRENTFILE->newsourcefile = NULL;	/* current file is now the last in the list */
  ownedfile->prevsourcefile = NULL;	/* pointer to owner now obsolete... */

  newusedfile->nextusedfile = CURRENTFILE->usedsourcefile;	/* set ptr to next record to current ptr to
								 * another used file */
  CURRENTFILE->usedsourcefile = newusedfile;	/* new used file now inserted into list */
  newusedfile->ownedsourcefile = ownedfile;	/* the inserted record now points to previously owned file */
  return (CURRENTFILE);
}


/* CH_0004 : always returns non-NULL, ERR_NO_MEMORY is signalled by exception */
struct sourcefile *
Newfile (struct sourcefile *curfile, char *fname)
{
    struct sourcefile *nfile;
    struct sourcefile *ret;

    nfile = xcalloc_struct(struct sourcefile);
    try {
	ret = Setfile(curfile, nfile, fname);
    }
    catch(RuntimeException) {
	xfree0(nfile);
	rethrow("");
    }

    return ret;
}


struct sourcefile *
Setfile (struct sourcefile *curfile,	/* pointer to record of current source file */
	 struct sourcefile *nfile,	/* pointer to record of new
					 * source file */
	 char *filename)
{
  nfile->fname = xstrdup(filename);	/* pointer to filename string */
  nfile->prevsourcefile = curfile;
  nfile->newsourcefile = NULL;
  nfile->usedsourcefile = NULL;
  nfile->filepointer = 0;
  nfile->line = 0;			/* Reset to 0 as line counter during parsing */
  return (nfile);
}


int
Flncmp(char *f1, char *f2)
{
   int i;

   if (strlen(f1) != strlen(f2))
     return -1;
   else
     {
       i = strlen(f1);
       while(--i >= 0)
         if( tolower(f1[i]) != tolower(f2[i]) )
           return -1;

       /* filenames equal */
       return 0;
     }
}


struct sourcefile *
FindFile (struct sourcefile *srcfile, char *flnm)
{
  struct sourcefile *foundfile;

  if (srcfile != NULL)
    {
      if ((foundfile = FindFile(srcfile->prevsourcefile, flnm)) != NULL)
        return foundfile;	/* trying to include an already included file recursively! */

      if (Flncmp(srcfile->fname,flnm) == 0)
        return srcfile;	/* this include file already used! */
      else
        return NULL;	/* this include file didn't match filename searched */
    }
  else
    return NULL;
}



void 
PatchListFile (struct expr *pass2expr, long c)
{
  int i;

  if (pass2expr->listpos == -1)
    return;			/* listing wasn't switched ON during pass1 */
  else
    {
      fseek (listfile, pass2expr->listpos, SEEK_SET);	/* set file pointer in list file */
      switch (pass2expr->rangetype & RANGE)
	{			/* look only at range bits */
	case RANGE_JROFFSET:
	case RANGE_8UNSIGN:
	case RANGE_8SIGN:
	  fprintf (listfile, "%02X", (unsigned int) c);
	  break;

	case RANGE_16CONST:
	  fprintf (listfile, "%02X %02X", (unsigned int) (c & 0xFF), (unsigned int) (c >> 8) );
	  break;

	case RANGE_32SIGN:
	  for (i = 0; i < 4; i++)
	    {
	      fprintf (listfile, "%02X ", (unsigned int) (c & 0xFF) );
	      c >>= 8;
	    }
	  break;
	}
    }
}



/*
 * Write current source line to list file with Hex dump of assembled instruction
 */
void 
WriteListFile (void)
{
  int len, k;
  size_t byteptr;

  if (strlen (line) == 0)
    strcpy (line, "\n");

  len = get_PC() - get_oldPC();
  byteptr = get_code_size() - len;
  if (len == 0)
    fprintf (listfile, "%-4d  %04X%14s%s", CURRENTFILE->line, (unsigned short) get_oldPC(), "", line);		/* no bytes generated */
  else if (len <= 4)
    {
      fprintf (listfile, "%-4d  %04X  ", CURRENTFILE->line, (unsigned short) get_oldPC());
      for (k = 0; k < len; k++)
	fprintf (listfile, "%02X ", get_byte(&byteptr));
      fprintf (listfile, "%*s%s", (unsigned short) (4 - len) * 3, "", line);
    }
  else
    {
      while (len)
	{
	  LineCounter ();
	  if (len)
	    fprintf (listfile, "%-4d  %04X  ", CURRENTFILE->line, (unsigned short) (get_PC() - len));
	  for (k = (len - 32 > 0) ? 32 : len; k; k--, len--)
	    fprintf (listfile, "%02X ", get_byte(&byteptr));
	  fprintf (listfile, "\n");
	}
      fprintf (listfile, "%18s%s", "", line);
      LineCounter ();
    }
  LineCounter ();			/* Update list file line counter - check page boundary */
  listfileptr = ftell (listfile);	/* Get file position for beginning of next line in list file */

  set_oldPC();
}


void 
LineCounter (void)
{
  if (++LINENR > PAGELEN)
    {
      fprintf (listfile, "\x0C\n");	/* send FORM FEED to file */
      WriteHeader ();
      LINENR = 6;
    }
}


void 
WriteHeader (void)
{
#ifdef QDOS
  fprintf (listfile, "%s %s, %s", _prog_name, _version, _copyright);
  fprintf (listfile, "%*.*s", 122 - strlen (_prog_name) - strlen (_version) - strlen (_copyright) - 3, strlen (date), date);
#else
  fprintf (listfile, "%s", copyrightmsg);
  fprintf (listfile, "%*.*s", (int)(122 - strlen (copyrightmsg)), (int) strlen (date), date);
#endif
  fprintf (listfile, "Page %03d%*s'%s'\n\n\n", ++PAGENR, (int) (122 - 9 - 2 - strlen (lstfilename)), "", lstfilename);
}


void 
WriteSymbol (symbol * n)
{
  int k;
  int space, tabulators;
  struct pageref *page;

  if (n->owner == CURRENTMODULE)
    {				/* Write only symbols related to current module */
      if ((n->type & SYMLOCAL) || (n->type & SYMXDEF))
	{
	  if ((n->type & SYMTOUCHED))
	    {
	      fprintf (listfile, "%s", n->symname);
	      space = COLUMN_WIDTH - strlen (n->symname);
	      for (tabulators = space % TAB_DIST ? space / TAB_DIST + 1 : space / TAB_DIST; tabulators > 0; tabulators--)
		xfputc('\t', listfile);
	      fprintf (listfile, "= %08lX", n->symvalue);
	      if (n->references != NULL)
		{
		  page = n->references->firstref;
		  fprintf (listfile, " : %3d* ", page->pagenr);
		  page = page->nextref;
		  k = 17;
		  while (page != NULL)
		    {
		      if (k-- == 0)
			{
			  fprintf (listfile, "\n%45s", "");
			  k = 16;
			  LineCounter ();
			}
		      fprintf (listfile, "%3d ", page->pagenr);
		      page = page->nextref;
		    }
		}
	      fprintf (listfile, "\n");
	      LineCounter ();
	    }
	}
    }
}


void 
WriteSymbolTable (char *msg, avltree * root)
{

  fseek (listfile, 0, SEEK_END);	/* File position to end of file */
  xfputc('\n', listfile);
  LineCounter ();
  xfputc('\n', listfile);
  LineCounter ();
  fprintf (listfile, "%s", msg);
  LineCounter ();
  xfputc('\n', listfile);
  LineCounter ();
  xfputc('\n', listfile);
  LineCounter ();

  inorder (root, (void (*)(void*)) WriteSymbol);        /* write symbol table */
}



