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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsline.c,v 1.1 2000-07-04 15:33:30 dom Exp $ */
/* $History: PRSLINE.C $ */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:30 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
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
/* User: Gbs          Date: 20-06-98   Time: 15:02 */
/* Updated in $/Z80asm */
/* GetSym() and Skipline() improved with EOF handling. */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "config.h"
#include "symbol.h"


/* external functions */
void ReportError (char *filename, short linenr, int errnum);

/* local functions */
long GetConstant (char *evalerr);
int IndirectRegisters (void);
int CheckRegister16 (void);
int CheckRegister8 (void);
int CheckCondition (void);
int GetChar (FILE *fptr);
enum symbols GetSym (void);
void Skipline (FILE *fptr);

/* global variables */
extern FILE *z80asmfile;
extern char ident[];
extern char separators[];
extern enum symbols sym, ssym[];
extern short currentline;
extern struct module *CURRENTMODULE;
extern enum flag EOL;


/* get a character from file with CR/LF/CRLF parsing capability.
 *
 * return '\n' byte if a CR/LF/CRLF variation line feed is found
 *
 */
int
GetChar (FILE *fptr)
{
  int c;
  
  c = fgetc (fptr);
  if (c == 13)
    {
      /* Mac/Z88 line feed found,poll for MSDOS line feed */
      c = fgetc (fptr);    
      if (c != 10)
          ungetc (c, fptr);	/* push non-line-feed character back into file stream */
      
      c = '\n';	/* always return the symbolic '\n' for line feed */
    }
  else
    if (c == 10)
      c = '\n';	/* UNIX/QDOS line feed */
      
  return c;	/* return all other characters */
}


enum symbols 
GetSym (void)
{
  char *instr;
  int c, chcount = 0;

  ident[0] = '\0';

  if (EOL == ON)
    {
      sym = newline;
      return sym;
    }
  for (;;)
    {				/* Ignore leading white spaces, if any... */
      if (feof (z80asmfile))
	{
	  sym = newline;
	  EOL = ON;
	  return newline;
	}
      else
	{
	  c = GetChar (z80asmfile);
	  if ((c == '\n') || (c == EOF) || (c == '\x1A'))
	    {
	      sym = newline;
	      EOL = ON;
	      return newline;
	    }
	  else if (!isspace (c))
	    break;
	}
    }

  instr = strchr (separators, c);
  if (instr != NULL)
    {
      sym = ssym[instr - separators];	/* index of found char in separators[] */
      if (sym == semicolon)
	{
	  Skipline (z80asmfile);	/* ignore comment line, prepare for next line */
	  sym = newline;
	}
      return sym;
    }
  ident[chcount++] = (char) toupper (c);
  switch (c)
    {
    case '$':
      sym = hexconst;
      break;

    case '@':
      sym = binconst;
      break;

    case '#':
      sym = name;
      break;

    default:
      if (isdigit (c))
	{
	  sym = decmconst;	/* a decimal number found */
	}
      else
	{
	  if (isalpha (c) || c == '_' )
	    {
	      sym = name;	/* an identifier found */
	    }
	  else
	    {
	      sym = nil;	/* rubbish ... */
	    }
	}
      break;
    }

  /* Read identifier until space or legal separator is found */
  if (sym == name)
    {
      for (;;)
	{
	  if (feof (z80asmfile))
	    {
	      break;
	    }
	  else
	    {
	      c = GetChar (z80asmfile);
	      if ((c != EOF) && (!iscntrl (c)) && (strchr (separators, c) == NULL))
		{
		  if (!isalnum (c))
		    {
		      if (c != '_')
			{
			  sym = nil;
			  break;
			}
		      else
			{
			  ident[chcount++] = '_';	/* underscore in identifier */
			}
		    }
		  else
		    {
		      ident[chcount++] = (char) toupper (c);
		    }
		}
	      else
		{
		  ungetc (c, z80asmfile);	/* puch character back into stream for next read */
		  break;
		}
	    }
	}
    }
  else
    {
      for (;;)
	{
	  if (feof (z80asmfile))
	    {
	      break;
	    }
	  else
	    {
	      c = GetChar (z80asmfile);
	      if ((c != EOF) && !iscntrl (c) && (strchr (separators, c) == NULL))
		{
		  ident[chcount++] = c;
		}
	      else
		{
		  ungetc (c, z80asmfile);	/* puch character back into stream for next read */
		  break;
		}
	    }
	}
    }

  ident[chcount] = '\0';
  return sym;
}



void 
Skipline (FILE *fptr)
{
  int c;

  if (EOL == OFF)
    {
      while (!feof (fptr))
	{
	  c = GetChar (fptr);
	  if ((c == '\n') || (c == EOF))
	    break;		/* get to beginning of next line... */
	}
      EOL = ON;
    }
}




int 
CheckCondition (void)
{
  switch (*ident)
    {
    case 'Z':			/* is it zero flag ? */
      if (*(ident + 1) == '\0')
	return (1);
      else
	return -1;

    case 'N':			/* is it NZ, NC ? */
      if (*(ident + 2) == '\0')
	switch (*(ident + 1))
	  {
	  case 'Z':
	    return (0);
	  case 'C':
	    return (2);
	  default:
	    return (-1);
	  }
      else
	return -1;

    case 'C':			/* is it carry flag ? */
      if (*(ident + 1) == '\0')
	return (3);
      else
	return -1;

    case 'P':
      switch (*(ident + 1))
	{
	case '\0':
	  return (6);		/* P */

	case 'O':	
	  if (*(ident + 2) == '\0')
	    return (4);		/* PO */
	  else
	    return -1;

	case 'E':
	  if (*(ident + 2) == '\0')
	    return (5);		/* PO */
	  else
	    return (-1);
	default:
	  return (-1);
	}

    case 'M':			/* is it minus flag ? */
      if (*(ident + 1) == '\0')
	return (7);
      else
	return -1;

    default:
      return -1;
    }
}


int 
CheckRegister8 (void)
{
  if (sym == name)
    if (*(ident + 1) == '\0')
      {
	switch (*ident)
	  {
	  case 'A':
	    return 7;
	  case 'H':
	    return 4;
	  case 'B':
	    return 0;
	  case 'L':
	    return 5;
	  case 'C':
	    return 1;
	  case 'D':
	    return 2;
	  case 'E':
	    return 3;
	  case 'I':
	    return 8;
	  case 'R':
	    return 9;
	  case 'F':
	    return 6;
	  }
      }
    else
      {
	if (strcmp (ident, "IXL") == 0)
	  return (8 + 5);
	else if (strcmp (ident, "IXH") == 0)
	  return (8 + 4);
	else if (strcmp (ident, "IYL") == 0)
	  return (16 + 5);
	else if (strcmp (ident, "IYH") == 0)
	  return (16 + 4);
      }
  return -1;
}


int 
CheckRegister16 (void)
{
  if (sym == name)
    if (*(ident + 2) == '\0')
      switch (*ident)
	{
	case 'H':
	  if (*(ident + 1) == 'L')
	    return (2);
	  break;

	case 'B':
	  if (*(ident + 1) == 'C')
	    return (0);
	  break;

	case 'D':
	  if (*(ident + 1) == 'E')
	    return (1);
	  break;

	case 'A':
	  if (*(ident + 1) == 'F')
	    return (4);
	  break;

	case 'S':
	  if (*(ident + 1) == 'P')
	    return (3);
	  break;

	case 'I':
	  switch (*(ident + 1))
	    {
	    case 'X':
	      return (5);
	    case 'Y':
	      return (6);
	    }
	}
  return -1;
}


/*
 * This function will parse the current line for an indirect addressing mode. The return code can be:
 * 
 * 0 - 2   :   (BC); (DE); (HL) 5,6     :   (IX <+|- expr.> ); (IY <+|- expr.> ) 7       :   (nn), nn = 16bit address
 * expression
 * 
 * The function also returns a pointer to the parsed expression, now converted to postfix.
 */
int 
IndirectRegisters (void)
{
  int reg16;

  GetSym ();
  reg16 = CheckRegister16 ();
  switch (reg16)
    {
    case 0:			/* 0 to 2 = BC, DE, HL */
    case 1:
    case 2:
      if (GetSym () == rparen)
	{			/* (BC) | (DE) | (HL) | ? */
	  GetSym ();
	  return (reg16);	/* indicate (BC), (DE), (HL) */
	}
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);	/* Right bracket missing! */
	  return -1;
	}

    case 5:			/* 5, 6 = IX, IY */
    case 6:
      GetSym ();		/* prepare expression evaluation */
      return (reg16);

    case -1:			/* sym could be a '+', '-' or a symbol... */
      return 7;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return -1;
    }
}


long 
GetConstant (char *evalerr)
{
  long size, l, intresult = 0;
  unsigned short bitvalue = 1;

  *evalerr = 0;			/* preset to no errors */

  if ((sym != hexconst) && (sym != binconst) && (sym != decmconst))
    {
      *evalerr = 1;
      return (0);		/* syntax error - illegal constant definition */
    }
  size = strlen (ident);
  if (sym != decmconst)
    if ((--size) == 0)
      {
	*evalerr = 1;
	return (0);		/* syntax error - no constant specified */
      }
  switch (ident[0])
    {
    case '@':
      if (size > 8)
	{
	  *evalerr = 1;
	  return (0);		/* max 8 bit */
	}
      for (l = 1; l <= size; l++)
	if (strchr ("01", ident[l]) == NULL)
	  {
	    *evalerr = 1;
	    return (0);
	  }
      /* convert ASCII binary to integer */
      for (l = size; l >= 1; l--)
	{
	  if (ident[l] == '1')
	    intresult += bitvalue;
	  bitvalue <<= 1;	/* logical shift left & 16 bit 'adder' */
	}
      return (intresult);

    case '$':
      for (l = 1; l <= size; l++)
	if (isxdigit (ident[l]) == 0)
	  {
	    *evalerr = 1;
	    return (0);
	  }
      sscanf ((char *) (ident + 1), "%lx", &intresult);
      return (intresult);

    default:
      for (l = 0; l <= (size - 1); l++)
	if (isdigit (ident[l]) == 0)
	  {
	    *evalerr = 1;
	    return (0);
	  }
      return (atol (ident));
    }
}
