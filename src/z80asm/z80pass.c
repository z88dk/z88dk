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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80pass.c,v 1.2 2001-03-21 16:34:01 dom Exp $ */
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

#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include "config.h"
#include "symbol.h"


/* external functions */
void Skipline (FILE *fptr);
void WriteLong (long fptr, FILE * fileid);
void LinkModules (void);
void DefineOrigin (void);
void ParseIdent (enum flag interpret);
void ReportError (char *filename, short linenr, int errnum);
void RemovePfixlist (struct expr *pfixexpr);
void StoreExpr (struct expr *pfixexpr, char range);
int DefineSymbol (char *identifier, long value, unsigned char symboltype);
int GetChar(FILE *fptr);
long EvalPfixExpr (struct expr *pass2expr);
struct expr *ParseNumExpr (void);
enum symbols GetSym (void);
symbol *FindSymbol (char *identifier, avltree * treeptr);
char *AllocIdentifier (size_t len);

/* local functions */
void ifstatement (enum flag interpret);
void parseline (enum flag interpret);
void getline (void);
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
struct sourcefile *AllocFile (void);
struct usedfile *AllocUsedFile (void);


/* global variables */
extern FILE *z80asmfile, *listfile, *objfile, *mapfile;
extern char *date, line[], ident[], separators[];
extern char *lstfilename, *objfilename, objext[], binext[];
extern enum symbols sym;
extern enum flag listing, listing_CPY, verbose, writeline, symtable, z80bin, deforigin, EOL;
extern long PC, oldPC;
extern long EXPLICIT_ORIGIN;
extern unsigned char *codearea, *codeptr, PAGELEN;
extern size_t CODESIZE;
extern int ASSEMBLE_ERROR;
extern long listfileptr, TOTALLINES;
extern struct modules *modulehdr;	/* pointer to module header */
extern struct module *CURRENTMODULE;
extern int PAGENR, LINENR, TOTALERRORS;
extern int COLUMN_WIDTH, TAB_DIST;
extern avltree *globalroot;

#ifdef QDOS
extern char _prog_name[], _version[], _copyright[];
#else
extern char copyrightmsg[];
#endif


void 
Z80pass1 (void)
{
  line[0] = '\0';		/* reset contents of list buffer */

  while (!feof (z80asmfile))
    {
      if (listing)
	writeline = ON;
      parseline (ON);		/* before parsing it */

      switch (ASSEMBLE_ERROR)
	{
	case 3:
	case 12:
	  return;		/* Fatal errors, return immediatly... */
	}
    }
}



void 
getline (void)
{
  long fptr;
  int l,c;

  fptr = ftell (z80asmfile);		/* remember file position */

  c = '\0';
  for (l=0; (l<254) && (c!='\n'); l++) 
    {
      c = GetChar(z80asmfile); 
      if (c != EOF)
        line[l] = c;	/* line feed inclusive */
      else
        break;
    }
  line[l] = '\0'; 

  fseek (z80asmfile, fptr, SEEK_SET);	/* resume file position */
}



void 
parseline (enum flag interpret)
{
  FindSymbol (ASSEMBLERPC, globalroot)->symvalue = PC;	/* update assembler program counter */

  if (PC <= MAXCODESIZE)
    {				/* room for z80 machine code? */
      ++CURRENTFILE->line;
      ++TOTALLINES;
      if (listing)
	getline ();		/* get a copy of current source line */

      EOL = OFF;		/* reset END OF LINE flag */
      GetSym ();
      if (sym == fullstop || sym == label)
	{
	  if (interpret == ON)
	    {			/* Generate only possible label declaration if line parsing is allowed */
	      if (sym == label || GetSym () == name)
		{
		  DefineSymbol (ident, PC, SYMADDR | SYMTOUCHED);	/* labels must always be
									 * touched due to forward */
		  	GetSym ();	/* check for another identifier *//* referencing problems in
				   * expressions */
		}
	      else
		{
		  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);	/* a name must follow a
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
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);	/* Syntax error */
	}

      if (listing && writeline)
	WriteListFile ();	/* Write current source line to list file, if allowed */
    }
  else
    ReportError (NULL, 0, 12);	/* no more room in machine code area */
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
  long constant, i;
  long fptr_exprdecl, fptr_namedecl, fptr_modname, fptr_modcode, fptr_libnmdecl;
  unsigned char *patchptr;


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
		    ReportError (pass2expr->srcfile, pass2expr->curline, 25);	/* JR, DJNZ used an
										 * external label - */
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, 2);
		  prevJR = curJR;
		  curJR = curJR->nextref;	/* get ready for next JR instruction */
		  free (prevJR);
		}
	      else
		ReportError (pass2expr->srcfile, pass2expr->curline, 2);
	    }
	  else
	    {
	      patchptr = codearea + pass2expr->codepos;		/* absolute patch pos. in memory buffer */
	      switch (pass2expr->rangetype & RANGE)
		{
		case RANGE_JROFFSET:
		  constant -= curJR->PCaddr;	/* get module PC at JR instruction */
		  if (constant >= -128 && constant <= 127)
		    {
		      *patchptr = (char) constant;	/* opcode is stored, now store
							 * relative jump */
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, 7);
		  prevJR = curJR;
		  curJR = curJR->nextref;	/* get ready for JR instruction */
		  free (prevJR);
		  break;

		case RANGE_8UNSIGN:
	       *patchptr = (unsigned char) constant;	/* opcode is stored, now store byte */
		  break;

		case RANGE_8SIGN:
		  if (constant >= -128 && constant <= 255)
		    {
		      *patchptr = (char) constant;	/* opcode is stored, now store
							 * signed operand */
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, 7);
		  break;

		case RANGE_16CONST:
		  if (constant >= -32768 && constant <= 65535)
		    {
		      *patchptr++ = (unsigned short) constant & 255;	/* modulus 256 */
		      *patchptr = (unsigned short) constant >> 8;	/* div 256 */
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, 7);
		  break;

		case RANGE_32SIGN:
		  if (constant >= LONG_MIN && constant <= LONG_MAX)
		    {
		      for (i = 0; i < 4; i++)
			{
			  *patchptr++ = (unsigned char) constant & 255;
			  constant >>= 8;
			}
		    }
		  else
		    ReportError (pass2expr->srcfile, pass2expr->curline, 7);
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

      free (CURRENTMODULE->mexpr);	/* Release header of expressions list */
      free (CURRENTMODULE->JRaddr);	/* Release header of relative jump address list */
      CURRENTMODULE->mexpr = NULL;
      CURRENTMODULE->JRaddr = NULL;
    }
  if ((TOTALERRORS == 0) && symtable)
    {
      WriteSymbolTable ("Local Module Symbols:", CURRENTMODULE->localroot);
      WriteSymbolTable ("Global Module Symbols:", globalroot);
    }
  fptr_namedecl = ftell (objfile);
  inorder (CURRENTMODULE->localroot, (void (*)()) StoreLocalName);	/* Store Local Name declarations to relocatable file */
  inorder (globalroot, (void (*)()) StoreGlobalName);	/* Store Global name declarations to relocatable file */

  fptr_libnmdecl = ftell (objfile);	/* Store library reference names */
  inorder (globalroot, (void (*)()) StoreLibReference);	/* Store library reference name declarations to relocatable file */

  fptr_modname = ftell (objfile);
  constant = strlen (CURRENTMODULE->mname);
  fputc (constant, objfile);	/* write length of module name to relocatable file */
  fwrite (CURRENTMODULE->mname, sizeof (char), (size_t) constant, objfile);	/* write module name to relocatable
										 * file       */
  if ((constant = codeptr - codearea) == 0)
    fptr_modcode = -1;		/* no code generated!  */
  else
    {
      fptr_modcode = ftell (objfile);
      fputc (constant % 256, objfile);	/* low byte of module code size */
      fputc (constant / 256, objfile);	/* high byte of module code size */
      fwrite (codearea, sizeof (char), (size_t) constant, objfile);
    }
  CODESIZE += constant;

  if (verbose)
    printf ("Size of module is %ld bytes\n", constant);

  fseek (objfile, 8, SEEK_SET);	/* set file pointer to point at ORG */
  if ((modulehdr->first == CURRENTMODULE))
    {
      if (deforigin)
	CURRENTMODULE->origin = EXPLICIT_ORIGIN;	/* use origin from command line */
    }
  fputc (CURRENTMODULE->origin % 256, objfile);		/* low byte of origin */
  fputc (CURRENTMODULE->origin / 256, objfile);		/* high byte of origin */

  fptr_exprdecl = 30;		/* expressions always begins at file position 24 */

  if (fptr_namedecl == fptr_exprdecl)
    fptr_exprdecl = -1;		/* no expressions */
  if (fptr_libnmdecl == fptr_namedecl)
    fptr_namedecl = -1;		/* no name declarations */
  if (fptr_modname == fptr_libnmdecl)
    fptr_libnmdecl = -1;	/* no library reference declarations */

  WriteLong (fptr_modname, objfile);	/* write fptr. to module name */
  WriteLong (fptr_exprdecl, objfile);	/* write fptr. to name declarations */
  WriteLong (fptr_namedecl, objfile);	/* write fptr. to name declarations */
  WriteLong (fptr_libnmdecl, objfile);	/* write fptr. to library name declarations */
  WriteLong (fptr_modcode, objfile);	/* write fptr. to module code */
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
      fputc ('L', objfile);
      break;

    case SYMXDEF:
      if (node->type & SYMDEF)
	fputc ('X', objfile);
      else
	fputc ('G', objfile);
      break;
    }
  if (node->type & SYMADDR)	/* then write type of symbol */
    fputc ('A', objfile);	/* either a relocatable address */
  else
    fputc ('C', objfile);	/* or a constant */

  WriteLong (node->symvalue, objfile);

  b = strlen (node->symname);
  fputc (b, objfile);		/* write length of symbol name to relocatable file */
  fwrite (node->symname, sizeof (char), (size_t) b, objfile);	/* write symbol name to relocatable file */
}


void 
StoreLibReference (symbol * node)
{
  size_t b;

  if ((node->type & SYMXREF) && (node->type & SYMDEF) && (node->type & SYMTOUCHED))
    {
      b = strlen (node->symname);
      fputc ((int) b, objfile);	/* write length of symbol name to relocatable file */
      fwrite (node->symname, sizeof (char), b, objfile);	/* write symbol name to relocatable file */
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

  if ((newusedfile = AllocUsedFile ()) == NULL)
    {
      ReportError (NULL, 0, 3);	/* No room in operating system - stop assembler */
      return (CURRENTFILE);	/* return parameter pointer - nothing happended! */
    }
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


struct sourcefile *
Newfile (struct sourcefile *curfile, char *fname)
{
  struct sourcefile *nfile;

  if (curfile == NULL)
    {				/* file record has not yet been created */
      if ((curfile = AllocFile ()) == NULL)
	{
	  ReportError (NULL, 0, 3);
	  return (NULL);
	}
      else
	return (Setfile (NULL, curfile, fname));
    }
  else if ((nfile = AllocFile ()) == NULL)
    {
      ReportError (NULL, 0, 3);
      return (curfile);
    }
  else
    return (Setfile (curfile, nfile, fname));
}


struct sourcefile *
Setfile (struct sourcefile *curfile,	/* pointer to record of current source file */
	 struct sourcefile *nfile,	/* pointer to record of new
					 * source file */
	 char *filename)
{				/* pointer to filename string */
  if ((nfile->fname = AllocIdentifier (strlen (filename) + 1)) == NULL)
    {
      ReportError (NULL, 0, 3);
      return (nfile);
    }
  nfile->prevsourcefile = curfile;
  nfile->newsourcefile = NULL;
  nfile->usedsourcefile = NULL;
  nfile->filepointer = 0;
  nfile->line = 0;		/* Reset to 0 as line counter during parsing */
  nfile->fname = strcpy (nfile->fname, filename);
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
	  fprintf (listfile, "%02X %02X", (unsigned int) (c % 256), (unsigned int) (c / 256) );
	  break;

	case RANGE_32SIGN:
	  for (i = 0; i < 4; i++)
	    {
	      fprintf (listfile, "%02X ", (unsigned int) (c & 255) );
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
  int l, k;

  if (strlen (line) == 0)
    strcpy (line, "\n");

  l = PC - oldPC;
  if (l == 0)
    fprintf (listfile, "%-4d  %04X%14s%s", CURRENTFILE->line, (unsigned short) oldPC, "", line);		/* no bytes generated */
  else if (l <= 4)
    {
      fprintf (listfile, "%-4d  %04X  ", CURRENTFILE->line, (unsigned short) oldPC);
      for (; l; l--)
	fprintf (listfile, "%02X ", *(codeptr - l));
      fprintf (listfile, "%*s%s", (unsigned short) (4 - (PC - oldPC)) * 3, "", line);
    }
  else
    {
      while (l)
	{
	  LineCounter ();
	  if (l)
	    fprintf (listfile, "%-4d  %04X  ", CURRENTFILE->line, (unsigned short) (PC - l));
	  for (k = (l - 32 > 0) ? 32 : l; k; k--)
	    fprintf (listfile, "%02X ", *(codeptr - l--));
	  fprintf (listfile, "\n");
	}
      fprintf (listfile, "%18s%s", "", line);
      LineCounter ();
    }
  LineCounter ();			/* Update list file line counter - check page boundary */
  listfileptr = ftell (listfile);	/* Get file position for beginning of next line in list file */

  oldPC = PC;
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
  fprintf (listfile, "%*.*s", (int) 122 - strlen (copyrightmsg), (int) strlen (date), date);
#endif
  fprintf (listfile, "Page %03d%*s'%s'\n\n\n", ++PAGENR, (int) 122 - 9 - 2 - strlen (lstfilename), "", lstfilename);
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
		fputc ('\t', listfile);
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
  fputc ('\n', listfile);
  LineCounter ();
  fputc ('\n', listfile);
  LineCounter ();
  fprintf (listfile, "%s", msg);
  LineCounter ();
  fputc ('\n', listfile);
  LineCounter ();
  fputc ('\n', listfile);
  LineCounter ();

  inorder (root, (void (*)()) WriteSymbol);	/* write symbol table */
}



struct usedfile *
AllocUsedFile (void)
{
  return (struct usedfile *) malloc (sizeof (struct usedfile));
}


struct sourcefile *
AllocFile (void)
{
  return (struct sourcefile *) malloc (sizeof (struct sourcefile));
}
