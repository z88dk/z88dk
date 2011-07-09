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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsline.c,v 1.15 2011-07-09 01:46:00 pauloscustodio Exp $ */
/* $Log: prsline.c,v $
/* Revision 1.15  2011-07-09 01:46:00  pauloscustodio
/* Added Log keyword
/* */

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
#include "z80asm.h"
#include "symbol.h"


/* external functions */
void ReportError (char *filename, int linenr, int errnum);

/* local functions */
long GetConstant (char *evalerr);
int IndirectRegisters (void);
int CheckRegister16 (void);
int CheckRegister8 (void);
int CheckCondition (void);
int GetChar (FILE *fptr);
enum symbols GetSym (void);
void Skipline (FILE *fptr);
int CheckBaseType(int chcount);

/* global variables */
extern FILE *z80asmfile;
extern char ident[];
extern char separators[];
extern enum symbols sym, ssym[];
extern int currentline;
extern struct module *CURRENTMODULE;
extern enum flag EOL, swapIXIY;


char  *temporary_start;
char  *temporary_ptr = NULL;


void UnGet(int c, FILE *fp)
{
  if ( temporary_ptr ) 
    {
      temporary_ptr--;
    } 
  else 
    {
      ungetc(c,fp);
    }
}




void 
SetTemporaryLine(char *line)
{
    temporary_start = temporary_ptr = line;
}

/* get a character from file with CR/LF/CRLF parsing capability.
 *
 * return '\n' byte if a CR/LF/CRLF variation line feed is found
 *
 */
int
GetChar (FILE *fptr)
{
  int c;

  if ( temporary_ptr != NULL )
    {
      if ( *temporary_ptr != 0 ) 
        {
          c = *temporary_ptr++;
          return c;
        } 
      temporary_ptr = NULL;
    }
      
  
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
          if ((c == '\n') || (c == EOF) || (c == '\x1A')
              || (c == '\0'))	        /* BUG_0001 Bugfix read overrun in OBJ file expression */
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
    case '%':
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
                  if ( c != ':' ) 
                    UnGet (c, z80asmfile);	/* puch character back into stream for next read */
                  else 
                    sym = label;
                  break;
                }
            }
        }
      chcount = CheckBaseType(chcount);             
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
                  UnGet (c, z80asmfile);	/* puch character back into stream for next read */
                  break;
                }
            }
        }
      chcount = CheckBaseType(chcount);                   
    }

  ident[chcount] = '\0';

  return sym;
}

int
CheckBaseType(int chcount)
{
  int   i;

  if ( !isxdigit(ident[0]) || chcount < 2 )      /* If it's not a hex digit straight off then reject it */
	return chcount;

  /* C style hex number */
  if ( chcount > 2 && strncmp(ident,"0x",2) == 0 ) 
	{
      for ( i = 2; i < chcount; i++ ) 
		{
          if ( !isxdigit(ident[i]) )
			break;
		}
      if ( i == chcount ) 
		{
          for ( i = 2; i < chcount ; i++ )
			ident[i-1] = ident[i];
          ident[0] = '$';
          sym = hexconst;
          return ( chcount - 1 );
		}
	}
  /* Check for this to be a hex num here */
  for ( i = 0; i <  chcount ; i++ ) 
	{
      if ( !isxdigit(ident[i])  )
		break;
    }
  if ( i == ( chcount - 1)  ) 
	{
      if ( toupper(ident[i]) == 'H' ) 
		{
          for ( i = (chcount-1); i >= 0 ; i-- ) 
			ident[i+1] = ident[i];
          ident[0] = '$';
          sym = hexconst;
          return chcount;
		} else {
        return chcount;      /* If we reached end of hex digits and the last one wasn't a 'h', then something is wrong, so return */
      }
    }
  /* Check for binary constant (ends in b) */
  for ( i = 0; i <  chcount ; i++ ) 
	{
      if ( ident[i] != '0' && ident[i] != '1'  )
		break;
    }
  if ( i == ( chcount - 1) && toupper(ident[i]) == 'B' ) 
	{
      for ( i = (chcount-1); i >= 0 ; i-- ) 
		ident[i+1] = ident[i];
      ident[0] = '@';
      sym = binconst;
      return chcount;
    }
  /* Check for decimal (we default to it in anycase..but */
  for ( i = 0; i <  chcount ; i++ ) 
	{
      if ( !isdigit(ident[i])  )
		break;
    }
  if ( i == ( chcount - 1) && toupper(ident[i]) == 'D' ) 
	{
      sym = decmconst;
      return chcount-1;	    
    }
  return chcount;
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


struct 
  {
    char          *name;
    int            flags;
    int            cpu;
  } 
flags[] = 
  {
    { "Z",    FLAGS_Z,  CPU_ALL },
    { "NZ",   FLAGS_NZ, CPU_ALL },
    { "C",    FLAGS_C,  CPU_ALL },
    { "NC",   FLAGS_NC, CPU_ALL },
    { "PE",   FLAGS_PE, CPU_ALL },   /* Not for jr, emu for RCM */
    { "PO",   FLAGS_PO, CPU_ALL },   /* Not for jr, emu for RCM */
    { "P",    FLAGS_P,  CPU_ALL },   /* Not for jr, emu for RCM */
    { "M",    FLAGS_M,  CPU_ALL },   /* Not for jr, emu for RCM */
#if 0
    { "LZ",   FLAGS_PO, CPU_RABBIT },  /* RCM alias */
    { "LO",   FLAGS_PE, CPU_RABBIT },  /* RCM alias */
    { "GTU",  FLAGS_GTU, CPU_RCM4000 }, /* RCM4000 */
    { "GT",   FLAGS_GT,  CPU_RCM4000 },  /* RCM4000 */
    { "LT",   FLAGS_LT,  CPU_RCM4000 },  /* RCM4000 */
    { "V",    FLAGS_V,   CPU_RCM4000 },   /* RCM4000 */
#endif
  };



int 
CheckCondition(void)
{
    int     i;
    char   *text = ident;
    int     len = strlen(text);

    for ( i = 0; i < sizeof(flags) / sizeof(flags[0]); i++ ) {
        if ( len != strlen(flags[i].name) ) {
            continue;
        }
        if ( strcmp(text, flags[i].name) == 0 ) {            
            if ( (cpu_type & flags[i].cpu) == 0 ) {
                continue;
            }
            return flags[i].flags;
        }
    }
    return -1;
}


int 
CheckRegister8 (void)
{
  if (sym == name)
    {
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
            {
              if ( (cpu_type & CPU_RABBIT) )
                {
                  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
                  return -1;
                }	
              return 8;
            }
            case 'R':
            {
              if ( (cpu_type & CPU_RABBIT) )
                {
                  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
                  return -1;
                }	
              return 9;
            }
            case 'F':
              return 6;
            }
        }
      else
        {
          if (strcmp (ident, "IXL") == 0)
            {
              if (swapIXIY == ON)
                return (16 + 5);
              else
                return (8 + 5);
            }

          else if (strcmp (ident, "IXH") == 0)
            {
              if (swapIXIY == ON)
                return (16 + 4);
              else
                return (8 + 4);
            }
	  
          else if (strcmp (ident, "IYL") == 0)
            {
              if (swapIXIY == ON)
                return (8 + 5);
              else
                return (16 + 5);
            }

          else if (strcmp (ident, "IYH") == 0)
            {
              if (swapIXIY == ON)
                return (8 + 4);
              else
                return (16 + 4);
            }

          else if (strcmp (ident, "IIR") == 0) /** Was 'I' register */
            {
              if ( (cpu_type & CPU_RABBIT) )
                {
                  return 8;
                }
            }
          else if (strcmp (ident, "EIR") == 0) /** Was 'R' register */
            {
              if ( (cpu_type & CPU_RABBIT) )
                {
                  return 9;
                }
            }
	  
        }
    }
  return -1;
}


int 
CheckRegister16 (void)
{
  if (sym == name) {
    if ( strcmp(ident,"HL") == 0 ) 
      {
        return REG16_HL;
      }
    else if ( strcmp(ident,"BC") == 0 ) 
      {
        return REG16_BC;
      }
    else if ( strcmp(ident,"DE") == 0 ) 
      {
        return REG16_DE;
      }
    else if ( strcmp(ident,"SP") == 0 ) 
      {
        return REG16_SP;
      }
    else if ( strcmp(ident,"AF") == 0 ) 
      {
        return REG16_AF;
      }
    else if ( strcmp(ident,"IX") == 0 ) 
      {
        return swapIXIY == ON ? REG16_IY : REG16_IX;
      }
    else if ( strcmp(ident,"IY") == 0 ) 
      {
        return swapIXIY == ON ? REG16_IX : REG16_IY;
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
    case REG16_BC:
    case REG16_DE:
    case REG16_HL:
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

    case REG16_IX:
    case REG16_IY:
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
    case '%':
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
