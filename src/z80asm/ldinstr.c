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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/ldinstr.c,v 1.3 2009-07-18 23:23:15 dom Exp $ */
/* $History: LDINSTR.C $ */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:05 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:29 */
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
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */

#include    <stdio.h>
#include    "config.h"
#include    "z80asm.h"
#include    "symbol.h"


/* external functions */
enum symbols GetSym (void);
void ReportError (char *filename, short linenr, int errnum);
void RemovePfixlist (struct expr *pfixexpr);
int ExprUnsigned8 (int listoffset);
int ExprSigned8 (int listoffset);
int ExprAddress (int listoffset);
int CheckRegister16 (void);
int CheckRegister8 (void);
struct expr *ParseNumExpr (void);
int IndirectRegisters (void);

/* local functions */
void LD_HL8bit_indrct (void);
void LD_16bit_reg (void);
void LD_index8bit_indrct (int reg);
void LD_address_indrct (long exprptr);
void LD_r_8bit_indrct (int reg);


/* global variables */
extern unsigned char *codeptr, *codearea;
extern long PC;
extern enum symbols sym, GetSym (void);
extern enum flag relocfile;
extern struct module *CURRENTMODULE;
extern FILE *z80asmfile;



void 
LD (void)
{
  long exprptr;
  int sourcereg, destreg;

  if (GetSym () == lparen)
    {
      exprptr = ftell (z80asmfile);	/* remember start of expression */
      switch (destreg = IndirectRegisters ())
        {
        case 2:
          LD_HL8bit_indrct ();	/* LD  (HL),  */
          break;

        case 5:
        case 6:
          LD_index8bit_indrct (destreg);	/* LD  (IX|IY+d),  */
          break;

        case 0:
          if (sym == comma)
            {			/* LD  (BC),A  */
              GetSym ();
              if (CheckRegister8 () == 7)
                {
                  *codeptr++ = 2;
                  ++PC;
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
            }
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
          break;

        case 1:
          if (sym == comma)
            {			/* LD  (DE),A  */
              GetSym ();
              if (CheckRegister8 () == 7)
                {
                  *codeptr++ = 18;
                  ++PC;
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
            }
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
          break;

        case 7:
          LD_address_indrct (exprptr);	/* LD  (nn),rr  ;  LD  (nn),A  */
          break;
        }
    }
  else
    switch (destreg = CheckRegister8 ())
      {
      case -1:
        LD_16bit_reg ();	/* LD rr,(nn)   ;  LD  rr,nn   ;   LD  SP,HL|IX|IY   */
        break;

      case 6:
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);	/* LD F,? */
        break;

      case 8:
        if (GetSym () == comma)
          {
            GetSym ();
            if (CheckRegister8 () == 7)
              {			/* LD  I,A */
                *codeptr++ = 237;
                *codeptr++ = 71;
                PC += 2;
              }
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
          }
        else
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
        break;

      case 9:
        if (GetSym () == comma)
          {
            GetSym ();
            if (CheckRegister8 () == 7)
              {			/* LD  R,A */
                *codeptr++ = 237;
                *codeptr++ = 79;
                PC += 2;
              }
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
          }
        else
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
        break;

      default:
        if (GetSym () == comma)
          {
            if (GetSym () == lparen)
              LD_r_8bit_indrct (destreg);	/* LD  r,(HL)  ;   LD  r,(IX|IY+d)  */
            else
              {
                sourcereg = CheckRegister8 ();
                if (sourcereg == -1)
                  {		/* LD  r,n */
                    if (destreg & 8)
                      {
                        if ( (cpu_type & CPU_RABBIT) )

                          {
                            ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
                            return;
                          }
                        *codeptr++ = 221;	/* LD IXl,n or LD IXh,n */
                        ++PC;
                      }
                    else if (destreg & 16)
                      {
                        if ( (cpu_type & CPU_RABBIT) )
                          {
                            ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
                            return;
                          }
                        *codeptr++ = 253;	/* LD  IYl,n or LD  IYh,n */
                        ++PC;
                      }
                    destreg &= 7;
                    *codeptr++ = destreg * 8 + 6;
                    ExprUnsigned8 (1);
                    PC += 2;
                    return;
                  }
                if (sourcereg == 6)
                  {
                    /* LD x, F */
                    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
                    return;
                  }
                if ((sourcereg == 8) && (destreg == 7))
                  {		/* LD A,I */
                    *codeptr++ = 237;
                    *codeptr++ = 87;
                    PC += 2;
                    return;
                  }
                if ((sourcereg == 9) && (destreg == 7))
                  {		/* LD A,R */
                    *codeptr++ = 237;
                    *codeptr++ = 95;
                    PC += 2;
                    return;
                  }
                if ((destreg & 8) || (sourcereg & 8))
                  {		/* IXl or IXh */
                    if ( (cpu_type & CPU_RABBIT) )
                      {
                        ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
                        return;
                      }
                    *codeptr++ = 221;
                    ++PC;
                  }
                else if ((destreg & 16) || (sourcereg & 16))
                  {		/* IYl or IYh */
                    if ( (cpu_type & CPU_RABBIT) )
                      {
                        ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
                        return;
                      }
                    *codeptr++ = 253;
                    ++PC;
                  }
                sourcereg &= 7;
                destreg &= 7;

                *codeptr++ = 64 + destreg * 8 + sourcereg;	/* LD  r,r  */
                ++PC;
              }
          }
        else
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
        break;
      }
}


/*
 * LD (HL),r LD   (HL),n
 */
void 
LD_HL8bit_indrct (void)
{
  int sourcereg;

  if (sym == comma)
    {
      GetSym ();
      switch (sourcereg = CheckRegister8 ())
	{
	case 6:
	case 8:
	case 9:
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	  break;

	case -1:		/* LD  (HL),n  */
	  *codeptr++ = 54;
	  ExprUnsigned8 (1);
	  PC += 2;
	  break;

	default:
	  *codeptr++ = 112 + sourcereg;		/* LD  (HL),r  */
	  ++PC;
	  break;
	}
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
}


/*
 * LD (IX|IY+d),r LD   (IX|IY+d),n
 */
void 
LD_index8bit_indrct (int destreg)
{
  int sourcereg;
  unsigned char *opcodeptr;

  if (destreg == 5)
    *codeptr++ = 221;
  else
    *codeptr++ = 253;
  opcodeptr = codeptr;		/* pointer to instruction opcode */
  *codeptr++ = 54;		/* preset 2. opcode to LD (IX|IY+d),n  */


  if (!ExprSigned8 (2))
    return;			/* IX/IY offset expression */
  if (sym != rparen)
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);	/* ')' wasn't found in line */
      return;
    }
  if (GetSym () == comma)
    {
      GetSym ();
      switch (sourcereg = CheckRegister8 ())
	{
	case 6:
	case 8:
	case 9:
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	  break;

	case -1:
	  ExprUnsigned8 (3);	/* Execute, store & patch 8bit expression for <n> */
	  PC += 4;
	  break;

	default:
	  *opcodeptr = 112 + sourcereg;		/* LD  (IX|IY+d),r  */
	  PC += 3;
	  break;
	}			/* end switch */
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
}


/*
 * LD  r,(HL) LD  r,(IX|IY+d) LD  A,(nn)
 */
void 
LD_r_8bit_indrct (int destreg)
{
  int sourcereg;

  switch (sourcereg = IndirectRegisters ())
    {
    case 2:
      *codeptr++ = 64 + destreg * 8 + 6;	/* LD   r,(HL)  */
      ++PC;
      break;

    case 5:
    case 6:
      if (sourcereg == 5)
	*codeptr++ = 221;
      else
	*codeptr++ = 253;
      *codeptr++ = 64 + destreg * 8 + 6;
      ExprSigned8 (2);
      PC += 3;
      break;

    case 7:			/* LD  A,(nn)  */
      if (destreg == 7)
	{
	  *codeptr++ = 58;
	  ExprAddress (1);
	  PC += 3;
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      break;

    case 0:
      if (destreg == 7)
	{			/* LD   A,(BC)  */
	  *codeptr++ = 10;
	  ++PC;
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      break;

    case 1:
      if (destreg == 7)
	{			/* LD   A,(DE)  */
	  *codeptr++ = 26;
	  ++PC;
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      break;
    }
}


void 
LD_address_indrct (long exprptr)
{
  int sourcereg;
  long bytepos;
  struct expr *addrexpr;

  if ((addrexpr = ParseNumExpr ()) == NULL)
    return;			/* parse to right bracket */
  else
    RemovePfixlist (addrexpr);	/* remove this expression again */

  if (sym != rparen)
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);	/* Right bracket missing! */
      return;
    }
  if (GetSym () == comma)
    {
      GetSym ();
      switch (sourcereg = CheckRegister16 ())
	{
	case 2:
	  *codeptr++ = 34;	/* LD  (nn),HL  */
	  bytepos = 1;
	  ++PC;
	  break;

	case 0:
	case 1:		/* LD  (nn),dd   => dd: BC,DE,SP  */
	case 3:
	  *codeptr++ = 237;
	  *codeptr++ = 67 + sourcereg * 16;
	  bytepos = 2;
	  PC += 2;
	  break;

	case 5:		/* LD  (nn),IX    ;    LD  (nn),IY   */
	case 6:
	  if (sourcereg == 5)
	    *codeptr++ = 221;
	  else
	    *codeptr++ = 253;
	  *codeptr++ = 34;
	  bytepos = 2;
	  PC += 2;
	  break;

	case -1:
	  if (CheckRegister8 () == 7)
	    {
	      *codeptr++ = 50;	/* LD  (nn),A  */
	      ++PC;
	      bytepos = 1;
	    }
	  else
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	      return;
	    }
	  break;

	default:
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	  return;
	}
    }
  else
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
      return;
    }

  fseek (z80asmfile, exprptr, SEEK_SET);	/* rewind fileptr to beginning of address expression */
  GetSym ();
  ExprAddress (bytepos);	/* re-parse, evaluate, etc. */
  PC += 2;
}


void 
LD_16bit_reg (void)
{
  int sourcereg, destreg;
  long bytepos;

  destreg = CheckRegister16 ();
  if (destreg != -1)
    if (GetSym () == comma)
      if (GetSym () == lparen)
	{
	  switch (destreg)
	    {
	    case 4:
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	      return;

	    case 2:
	      *codeptr++ = 42;	/* LD   HL,(nn)  */
	      bytepos = 1;
	      ++PC;
	      break;

	    case 5:		/* LD  IX,(nn)    LD  IY,(nn)  */
	    case 6:
	      if (destreg == 5)
		*codeptr++ = 221;
	      else
		*codeptr++ = 253;
	      *codeptr++ = 42;
	      bytepos = 2;
	      PC += 2;
	      break;

	    default:
	      *codeptr++ = 237;
	      *codeptr++ = 75 + destreg * 16;
	      bytepos = 2;
	      PC += 2;
	      break;
	    }

	  GetSym ();
	  ExprAddress (bytepos);
	  PC += 2;
	}
      else
	switch (sourcereg = CheckRegister16 ())
	  {
	  case -1:		/* LD  rr,nn  */
	    switch (destreg)
	      {
	      case 4:
		ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
		return;

	      case 5:
	      case 6:
		if (destreg == 5)
		  *codeptr++ = 221;
		else
		  *codeptr++ = 253;
		*codeptr++ = 33;
		bytepos = 2;
		PC += 2;
		break;

	      default:
		*codeptr++ = destreg * 16 + 1;
		bytepos = 1;
		++PC;
		break;
	      }

	    ExprAddress (bytepos);
	    PC += 2;
	    break;

	  case 2:
	    if (destreg == 3)
	      {			/* LD  SP,HL  */
		*codeptr++ = 249;
		++PC;
	      }
	    else
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	    break;

	  case 5:		/* LD  SP,IX    LD  SP,IY  */
	  case 6:
	    if (destreg == 3)
	      {
		if (sourcereg == 5)
		  *codeptr++ = 221;
		else
		  *codeptr++ = 253;
		*codeptr++ = 249;
		PC += 2;
	      }
	    else
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	    break;

	  default:
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
	    break;
	  }
    else
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
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

