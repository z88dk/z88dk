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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/exprprsr.c,v 1.4 2008-06-02 19:03:12 dom Exp $ */
/* $History: EXPRPRSR.C $ */
/*  */
/* *****************  Version 15  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:05 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:29 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:04 */
/* Updated in $/Z80asm */
/* General improvements on EvalPfixExpr(), due to changes in declaration */
/* rules of XDEF, XREF and LIB. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 14:24 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:13 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:06 */
/* Updated in $/Z80asm */
/* Improved handling of fgetc() character reading in relation to premature */
/* EOF handling (for character constants in expressions). */

#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "config.h"
#include "symbol.h"


/* external functions */
enum symbols GetSym (void);
void ReportError (char *filename, short linenr, int errnum);
void Pass2info (struct expr *expression, char constrange, long lfileptr);
long GetConstant (char *evalerr);
symbol *GetSymPtr (char *identifier);
symbol *FindSymbol (char *identifier, avltree * symbolptr);
char *AllocIdentifier (size_t len);
int GetChar (FILE *fptr);

/* local functions */
void list_PfixExpr (struct expr *pfixlist);
void RemovePfixlist (struct expr *pfixexpr);
void PushItem (long oprconst, struct pfixstack **stackpointer);
void ClearEvalStack (struct pfixstack **stackptr);
void CalcExpression (enum symbols opr, struct pfixstack **stackptr);
void NewPfixSymbol (struct expr *pfixexpr, long oprconst, enum symbols oprtype, char *symident, unsigned char type);
void StoreExpr (struct expr *pfixexpr, char range);
int ExprSigned8 (int listoffset);
int ExprUnsigned8 (int listoffset);
int ExprAddress (int listoffset);
int Condition (struct expr *pfixexpr);
int Expression (struct expr *pfixexpr);
int Term (struct expr *pfixexpr);
int Pterm (struct expr *pfixexpr);
int Factor (struct expr *pfixexpr);
long EvalPfixExpr (struct expr *pfixexpr);
long PopItem (struct pfixstack **stackpointer);
long Pw (long x, long y);
struct expr *Allocexpr (void);
struct expr *ParseNumExpr (void);
struct postfixlist *AllocPfixSymbol (void);
struct pfixstack *AllocStackItem (void);

/* global variables */
extern struct module *CURRENTMODULE;
extern avltree *globalroot;
extern enum symbols sym, pass1;
extern enum flag listing;
extern char ident[], separators[];
extern unsigned char *codearea, *codeptr;
extern long PC;
extern FILE *z80asmfile, *objfile;


int 
Factor (struct expr *pfixexpr)
{
  long constant;
  symbol *symptr;
  char eval_err;

  switch (sym)
    {
    case name:
      symptr = GetSymPtr (ident);
      if (symptr != NULL)
	{
	  if (symptr->type & SYMDEFINED)
	    {
	      pfixexpr->rangetype |= (symptr->type & SYMTYPE);	/* copy appropriate type bits */
	      NewPfixSymbol (pfixexpr, symptr->symvalue, number, NULL, symptr->type);
	    }
	  else
	    {
	      pfixexpr->rangetype |= ((symptr->type & SYMTYPE) | NOTEVALUABLE);	
              /* copy appropriate declaration bits */

	      NewPfixSymbol (pfixexpr, 0, number, ident, symptr->type);		
              /* symbol only declared, store symbol name */
	    }
	}
      else
	{
	  pfixexpr->rangetype |= NOTEVALUABLE;	/* expression not evaluable */
	  NewPfixSymbol (pfixexpr, 0, number, ident, SYM_NOTDEFINED);	/* symbol not found */
	}
      strcpy (pfixexpr->infixptr, ident);	/* add identifier to infix expr */
      pfixexpr->infixptr += strlen (ident);	/* update pointer */

      GetSym ();
      break;

    case hexconst:
    case binconst:
    case decmconst:
      strcpy (pfixexpr->infixptr, ident);	/* add constant to infix expr */
      pfixexpr->infixptr += strlen (ident);	/* update pointer */
      constant = GetConstant (&eval_err);

      if (eval_err == 1)
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 5);
	  return 0;		/* syntax error in expression */
	}
      else
	NewPfixSymbol (pfixexpr, constant, number, NULL, 0);

      GetSym ();
      break;

    case lparen:
    case lsquare:
      *pfixexpr->infixptr++ = separators[sym];	/* store '(' or '[' in infix expr */
      GetSym ();

      if (Condition (pfixexpr))
	{
	  if (sym == rparen || sym == rsquare)
	    {
	      *pfixexpr->infixptr++ = separators[sym];	/* store ')' or ']' in infix expr */
	      GetSym ();
	      break;
	    }
	  else
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 6);
	      return 0;
	    }
	}
      else
	return 0;

    case log_not:
      *pfixexpr->infixptr++ = '!';
      GetSym ();

      if (!Factor (pfixexpr))
	return 0;
      else
	NewPfixSymbol (pfixexpr, 0, log_not, NULL, 0);	/* logical NOT...  */
      break;

    case squote:
      *pfixexpr->infixptr++ = '\'';	/* store single quote in infix expr */
      if (feof (z80asmfile))
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
	  return 0;
	}
      else
	{
	  constant = GetChar (z80asmfile);
	  if (constant == EOF)
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
	      return 0;
	    }
	  else
	    {
	      *pfixexpr->infixptr++ = constant;		/* store char in infix expr */
	      if (GetSym () == squote)
		{
		  *pfixexpr->infixptr++ = '\'';
		  NewPfixSymbol (pfixexpr, constant, number, NULL, 0);
		}
	      else
		{
		  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 5);
		  return 0;
		}
	    }
	}

      GetSym ();
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 5);	/* syntax error */
      return 0;
    }

  return 1;			/* syntax OK */
}



int 
Pterm (struct expr *pfixexpr)
{

  if (!Factor (pfixexpr))
    return (0);

  while (sym == power)
    {
      *pfixexpr->infixptr++ = separators[power];	/* store '^' in infix expr */
      GetSym ();
      if (Factor (pfixexpr))
	NewPfixSymbol (pfixexpr, 0, power, NULL, 0);
      else
	return 0;
    }

  return (1);
}



int 
Term (struct expr *pfixexpr)
{
  enum symbols mulsym;

  if (!Pterm (pfixexpr))
    return (0);

  while ((sym == multiply) || (sym == divi) || (sym == mod))
    {
      *pfixexpr->infixptr++ = separators[sym];	/* store '/', '%', '*' in infix expr */
      mulsym = sym;
      GetSym ();
      if (Pterm (pfixexpr))
	NewPfixSymbol (pfixexpr, 0, mulsym, NULL, 0);
      else
	return 0;
    }

  return (1);
}



int 
Expression (struct expr *pfixexpr)
{
  enum symbols addsym = nil;

  if ((sym == plus) || (sym == minus))
    {
      if (sym == minus)
	*pfixexpr->infixptr++ = '-';
      
      addsym = sym;
      GetSym ();

      if (Term (pfixexpr))
	{
	  if (addsym == minus)
	    NewPfixSymbol (pfixexpr, 0, negated, NULL, 0);	/* operand is signed,
								                     * plus is redundant... */
	}
      else
	return (0);
    }
  else if (!Term (pfixexpr))
    return (0);

  while ((sym == plus) || (sym == minus) || (sym == bin_and) || (sym == bin_or) || (sym == bin_xor))
    {
      *pfixexpr->infixptr++ = separators[sym];
      addsym = sym;
      GetSym ();

      if (Term (pfixexpr))
	NewPfixSymbol (pfixexpr, 0, addsym, NULL, 0);
      else
	return (0);
    }

  return (1);
}


int 
Condition (struct expr *pfixexpr)
{
    enum symbols relsym = nil;

    if (!Expression (pfixexpr))
        return 0;

    relsym = sym;

    switch (sym)
    {
    case less:
        *pfixexpr->infixptr++ = '<';
        GetSym ();

        switch (sym)
        {
        case greater:
            *pfixexpr->infixptr++ = '>';
            relsym = notequal;	/* '<>' */
            GetSym ();
            break;

        case assign:
            *pfixexpr->infixptr++ = '=';
            relsym = lessequal;	/* '<=' */
            GetSym ();
            break;

        default:
            break;
        }
        break;

    case assign:
        *pfixexpr->infixptr++ = '=';
        GetSym ();
        break;

    case greater:
        *pfixexpr->infixptr++ = '>';

        if (GetSym () == assign)
        {
            *pfixexpr->infixptr++ = '=';
            relsym = greatequal;
            GetSym ();
        }
        break;

    default:
        return 1;			/* implicit (left side only) expression */
    }

    if (!Expression (pfixexpr))
        return 0;
    else
        NewPfixSymbol (pfixexpr, 0, relsym, NULL, 0);	/* condition... */

    return (1);
}




struct expr *
ParseNumExpr (void)
{
  struct expr *pfixhdr;
  enum symbols constant_expression = nil;

  if ((pfixhdr = Allocexpr ()) == NULL)
    {
      ReportError (NULL, 0, 3);
      return NULL;
    }
  else
    {
      pfixhdr->firstnode = NULL;
      pfixhdr->currentnode = NULL;
      pfixhdr->rangetype = 0;
      pfixhdr->stored = OFF;
      pfixhdr->codepos = codeptr - codearea;
      pfixhdr->infixexpr = NULL;
      pfixhdr->infixptr = NULL;

      if ((pfixhdr->infixexpr = (char *) calloc (128,sizeof (char))) == NULL)
	{
	  ReportError (NULL, 0, 3);
	  free (pfixhdr);
	  return NULL;
	}
      else
	pfixhdr->infixptr = pfixhdr->infixexpr;		/* initialise pointer to start of buffer */
    }

  if (sym == constexpr)
    {
      GetSym ();		/* leading '#' : ignore relocatable address expression */
      constant_expression = constexpr;	/* convert to constant expression */
      *pfixhdr->infixptr++ = '#';
    }

  if (Condition (pfixhdr))
    {				/* parse expression... */
      if (constant_expression == constexpr)
	NewPfixSymbol (pfixhdr, 0, constexpr, NULL, 0);	/* convert to constant expression */

      *pfixhdr->infixptr = '\0';			/* terminate infix expression */
      return pfixhdr;
    }
  else
    {
      RemovePfixlist (pfixhdr);
      return NULL;		/* syntax error in expression or no room */
    }				/* for postfix expression */
}



void 
StoreExpr (struct expr *pfixexpr, char range)
{
  unsigned char b;

  fputc (range, objfile);	/* range of expression */
  b = pfixexpr->codepos % 256U;
  fputc (b, objfile);		/* low byte of patchptr */
  b = pfixexpr->codepos / 256U;
  fputc (b, objfile);		/* high byte of patchptr */
  b = strlen (pfixexpr->infixexpr);
  fputc (b, objfile);		/* length prefixed string */
  fwrite (pfixexpr->infixexpr, sizeof (b), (size_t) b, objfile);
  fputc (0, objfile);		/* nul-terminate expression */

  pfixexpr->stored = ON;
}



long 
EvalPfixExpr (struct expr *pfixlist)
{
  struct pfixstack *stackptr = NULL;
  struct postfixlist *pfixexpr;
  symbol *symptr;

  pfixlist->rangetype &= EVALUATED;	/* prefix expression as evaluated */
  pfixexpr = pfixlist->firstnode;	/* initiate to first node */

  do
    {
      switch (pfixexpr->operatortype)
	{
	case number:
	  if (pfixexpr->id == NULL)	/* Is operand an identifier? */
	    PushItem (pfixexpr->operandconst, &stackptr);
	  else
	    {			/* symbol was not defined and not declared */
	      if (pfixexpr->type != SYM_NOTDEFINED)
		{		/* if all bits are set to zero */
		  if (pfixexpr->type & SYMLOCAL)
		    {
		      symptr = FindSymbol (pfixexpr->id, CURRENTMODULE->localroot);
                      pfixlist->rangetype |= (symptr->type & SYMTYPE);	/* copy appropriate type
									 * bits */
		      PushItem (symptr->symvalue, &stackptr);
		    }
		  else
		    {
		      symptr = FindSymbol (pfixexpr->id, globalroot);
		      if (symptr != NULL)
                        {
			  pfixlist->rangetype |= (symptr->type & SYMTYPE);	/* copy appropriate type
										 * bits */
		          if (symptr->type & SYMDEFINED)
			    PushItem (symptr->symvalue, &stackptr);
		          else
			    {
			      pfixlist->rangetype |= NOTEVALUABLE;
			      PushItem (0, &stackptr);
			    }
                        }
		      else
		        {
		          pfixlist->rangetype |= NOTEVALUABLE;
		          PushItem (0, &stackptr);
			}
		    }
		}
	      else
		{ /* try to find symbol now as either */

		  symptr = GetSymPtr (pfixexpr->id);	/* declared local or global */
		  if (symptr != NULL)
                    {
		      pfixlist->rangetype |= (symptr->type & SYMTYPE);	/* copy appropriate type bits */
                      if (symptr->type & SYMDEFINED)
		        PushItem (symptr->symvalue, &stackptr);
                      else
                        {
		          pfixlist->rangetype |= NOTEVALUABLE;
		          PushItem (0, &stackptr);
                        }
                    }
		  else
		    {
		      pfixlist->rangetype |= NOTEVALUABLE;
		      PushItem (0, &stackptr);
		    }
		}
	    }
	  break;

	case negated:
	  stackptr->stackconstant = -stackptr->stackconstant;
	  break;

	case log_not:
	  stackptr->stackconstant = !(stackptr->stackconstant);
	  break;

	case constexpr:
	  pfixlist->rangetype &= CLEAR_EXPRADDR;	/* convert to constant expression */
	  break;

	default:
	  CalcExpression (pfixexpr->operatortype, &stackptr);	/* plus minus, multiply, div,
								 * mod */
	  break;
	}

      pfixexpr = pfixexpr->nextoperand;		/* get next operand in postfix expression */
    }
  while (pfixexpr != NULL);


  if (stackptr != NULL)
    return PopItem (&stackptr);
  else
    return 0;			/* Unbalanced stack - probably during low memory... */
}



long 
Pw (long x, long y)
{
  long i;

  for (i = 1; y > 0; --y)
    i *= x;

  return i;
}



void 
CalcExpression (enum symbols opr, struct pfixstack **stackptr)
{
  long leftoperand, rightoperand;

  rightoperand = PopItem (stackptr);	/* first get right operator */
  leftoperand = PopItem (stackptr);	/* then get left operator... */

  switch (opr)
    {
    case bin_and:
      PushItem ((leftoperand & rightoperand), stackptr);
      break;

    case bin_or:
      PushItem ((leftoperand | rightoperand), stackptr);
      break;

    case bin_xor:
      PushItem ((leftoperand ^ rightoperand), stackptr);
      break;

    case plus:
      PushItem ((leftoperand + rightoperand), stackptr);
      break;

    case minus:
      PushItem ((leftoperand - rightoperand), stackptr);
      break;

    case multiply:
      PushItem ((leftoperand * rightoperand), stackptr);
      break;

    case divi:
      PushItem ((leftoperand / rightoperand), stackptr);
      break;

    case mod:
      PushItem ((leftoperand % rightoperand), stackptr);
      break;

    case power:
      PushItem (Pw (leftoperand, rightoperand), stackptr);
      break;

    case assign:
      PushItem ((leftoperand == rightoperand), stackptr);
      break;

    case less:
      PushItem ((leftoperand < rightoperand), stackptr);
      break;

    case greater:
      PushItem ((leftoperand > rightoperand), stackptr);
      break;

    case lessequal:
      PushItem ((leftoperand <= rightoperand), stackptr);
      break;

    case greatequal:
      PushItem ((leftoperand >= rightoperand), stackptr);
      break;

    case notequal:
      PushItem ((leftoperand != rightoperand), stackptr);
      break;

    default:
      PushItem (0, stackptr);
      break;
    }
}



void 
RemovePfixlist (struct expr *pfixexpr)
{
  struct postfixlist *node, *tmpnode;

  if (pfixexpr == NULL)
    return;

  node = pfixexpr->firstnode;
  while (node != NULL)
    {
      tmpnode = node->nextoperand;
      if (node->id != NULL)
	free (node->id);	/* Remove symbol id, if defined */
      
      free (node);
      node = tmpnode;
    }

  if (pfixexpr->infixexpr != NULL)
    free (pfixexpr->infixexpr);	/* release infix expr. string */

  free (pfixexpr);		/* release header of postfix expression */
}




void 
NewPfixSymbol (struct expr *pfixexpr,
	       long oprconst,
	       enum symbols oprtype,
	       char *symident,
	       unsigned char symtype)
{
  struct postfixlist *newnode;

  if ((newnode = AllocPfixSymbol ()) != NULL)
    {
      newnode->operandconst = oprconst;
      newnode->operatortype = oprtype;
      newnode->nextoperand = NULL;
      newnode->type = symtype;

      if (symident != NULL)
	{
	  newnode->id = AllocIdentifier (strlen (symident) + 1);	/* Allocate symbol */

	  if (newnode->id == NULL)
	    {
	      free (newnode);
	      ReportError (NULL, 0, 3);
	      return;
	    }
	  strcpy (newnode->id, symident);
	}
      else
	newnode->id = NULL;
    }
  else
    {
      ReportError (NULL, 0, 3);

      return;
    }

  if (pfixexpr->firstnode == NULL)
    {
      pfixexpr->firstnode = newnode;
      pfixexpr->currentnode = newnode;
    }
  else
    {
      pfixexpr->currentnode->nextoperand = newnode;
      pfixexpr->currentnode = newnode;
    }
}



void 
PushItem (long oprconst, struct pfixstack **stackpointer)
{
  struct pfixstack *newitem;

  if ((newitem = AllocStackItem ()) != NULL)
    {
      newitem->stackconstant = oprconst;
      newitem->prevstackitem = *stackpointer;	/* link new node to current node */
      *stackpointer = newitem;	/* update stackpointer to new item */
    }
  else
    ReportError (NULL, 0, 3);
}



long 
PopItem (struct pfixstack **stackpointer)
{

  struct pfixstack *stackitem;
  long constant;

  constant = (*stackpointer)->stackconstant;
  stackitem = *stackpointer;
  *stackpointer = (*stackpointer)->prevstackitem;	/* move stackpointer to previous item */
  free (stackitem);					/* return old item memory to OS */
  return (constant);
}



void 
ClearEvalStack (struct pfixstack **stackptr)
{
  while (*stackptr != NULL)
    PopItem (stackptr);		/* clear evaluation stack */
}




int 
ExprLong (int listoffset)
{

  struct expr *pfixexpr;
  long constant, i;
  int flag = 1;

  if ((pfixexpr = ParseNumExpr ()) != NULL)
    {				/* parse numerical expression */
      if ((pfixexpr->rangetype & EXPREXTERN) || (pfixexpr->rangetype & EXPRADDR))
	/* expression contains external reference or address label, must be recalculated during linking */
	StoreExpr (pfixexpr, 'L');

      if (pfixexpr->rangetype & EXPREXTERN)
	RemovePfixlist (pfixexpr);
      else
	{
	  if ((pfixexpr->rangetype & EXPRADDR) && (listing == OFF))	/* expression contains address
									   * label */
	    RemovePfixlist (pfixexpr);	/* no listing - evaluate during linking... */
	  else
	    {
	      if (pfixexpr->rangetype & NOTEVALUABLE)
		Pass2info (pfixexpr, RANGE_32SIGN, listoffset);
	      else
		{
		  constant = EvalPfixExpr (pfixexpr);
		  RemovePfixlist (pfixexpr);
		  if (constant >= LONG_MIN && constant <= LONG_MAX)
		    {
		      for (i = 0; i < 4; i++)
			{
			  *(codeptr + i) = constant & 255;
			  constant >>= 8;
			}
		    }
		  else
		    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 4);
		}
	    }
	}
    }
  else
    flag = 0;

  codeptr += 4;
  return flag;
}



int 
ExprAddress (int listoffset)
{
  struct expr *pfixexpr;
  long constant;
  int flag = 1;

  if ((pfixexpr = ParseNumExpr ()) != NULL)
    {				/* parse numerical expression */
      if ((pfixexpr->rangetype & EXPREXTERN) || (pfixexpr->rangetype & EXPRADDR))
	/* expression contains external reference or address label, must be recalculated during linking */
	StoreExpr (pfixexpr, 'C');

      if (pfixexpr->rangetype & EXPREXTERN)
	RemovePfixlist (pfixexpr);
      else
	{
	  if ((pfixexpr->rangetype & EXPRADDR) && (listing == OFF))	/* expression contains address
									   * label */
	    RemovePfixlist (pfixexpr);	/* no listing - evaluate during linking... */
	  else
	    {
	      if (pfixexpr->rangetype & NOTEVALUABLE)
		Pass2info (pfixexpr, RANGE_16CONST, listoffset);
	      else
		{
		  constant = EvalPfixExpr (pfixexpr);
		  RemovePfixlist (pfixexpr);
		  if (constant >= -32768 && constant <= 65535)
		    {
		      *codeptr = (unsigned short) constant % 256U;
		      *(codeptr + 1) = (unsigned short) constant / 256U;
		    }
		  else
		    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 4);
		}
	    }
	}
    }
  else
    flag = 0;

  codeptr += 2;
  return flag;
}


int 
ExprUnsigned8 (int listoffset)
{
  struct expr *pfixexpr;
  long constant;
  int flag = 1;

  if ((pfixexpr = ParseNumExpr ()) != NULL)
    {				/* parse numerical expression */
      if ((pfixexpr->rangetype & EXPREXTERN) || (pfixexpr->rangetype & EXPRADDR))
	/* expression contains external reference or address label, must be recalculated during linking */
	StoreExpr (pfixexpr, 'U');

      if (pfixexpr->rangetype & EXPREXTERN)
	RemovePfixlist (pfixexpr);
      else
	{
	  if ((pfixexpr->rangetype & EXPRADDR) && (listing == OFF))	/* expression contains address
									   * label */
	    RemovePfixlist (pfixexpr);	/* no listing - evaluate during linking... */
	  else
	    {
	      if (pfixexpr->rangetype & NOTEVALUABLE)
		Pass2info (pfixexpr, RANGE_8UNSIGN, listoffset);
	      else
		{
		  constant = EvalPfixExpr (pfixexpr);
		  RemovePfixlist (pfixexpr);
	       *codeptr = (unsigned char) constant;
		}
	    }
	}
    }
  else
    flag = 0;

  ++codeptr;
  return flag;
}



int 
ExprSigned8 (int listoffset)
{
  struct expr *pfixexpr;
  long constant;
  int flag = 1;

  if ((pfixexpr = ParseNumExpr ()) != NULL)
    {				/* parse numerical expression */
      if ((pfixexpr->rangetype & EXPREXTERN) || (pfixexpr->rangetype & EXPRADDR))
	/* expression contains external reference or address label, must be recalculated during linking */
	StoreExpr (pfixexpr, 'S');

      if (pfixexpr->rangetype & EXPREXTERN)
	RemovePfixlist (pfixexpr);
      else
	{
	  if ((pfixexpr->rangetype & EXPRADDR) && (listing == OFF))	/* expression contains address label */
	    RemovePfixlist (pfixexpr);	/* no listing - evaluate during linking... */
	  else
	    {
	      if (pfixexpr->rangetype & NOTEVALUABLE)
		Pass2info (pfixexpr, RANGE_8SIGN, listoffset);
	      else
		{
		  constant = EvalPfixExpr (pfixexpr);
		  RemovePfixlist (pfixexpr);
		  if (constant >= -128 && constant <= 255)
		    *codeptr = (char) constant;
		  else
		    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 4);
		}
	    }
	}
    }
  else
    flag = 0;

  ++codeptr;
  return flag;
}



struct expr *
Allocexpr (void)
{
  return (struct expr *) malloc (sizeof (struct expr));
}



struct postfixlist *
AllocPfixSymbol (void)
{
  return (struct postfixlist *) malloc (sizeof (struct postfixlist));
}



struct pfixstack *
AllocStackItem (void)
{
  return (struct pfixstack *) malloc (sizeof (struct pfixstack));
}
