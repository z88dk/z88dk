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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/ldinstr.c,v 1.12 2011-10-07 17:53:04 pauloscustodio Exp $ */
/* $Log: ldinstr.c,v $
/* Revision 1.12  2011-10-07 17:53:04  pauloscustodio
/* BUG_0015 : Relocation issue - dubious addresses come out of linking
/* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
/* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
/* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
/* The effect was that all address calculations at link phase were considering
/*  a start offset of zero for all modules.
/* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
/* - Consequence of these two issues were all linked addresses wrong.
/*
/* Revision 1.11  2011/08/19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* Revision 1.10  2011/07/18 00:48:25  pauloscustodio
/* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
/*
/* Revision 1.9  2011/07/12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.8  2011/07/11 16:21:12  pauloscustodio
/* Removed references to dead variable 'relocfile'.
/*
/* Revision 1.7  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.6  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.5  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/* 
/* Revision 1.4  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/* 
/* Revision 1.3  2009/07/18 23:23:15  dom
/* clean up the code a bit more (Formatting and a fewer magic numbers)
/* 
/* Revision 1.2  2009/05/28 19:20:16  dom
/* For the RCM SLL isn't a valid opcode, neither is anything using ixh,ixl,iyh
/* or iyl.
/* 
/* Revision 1.1  2000/07/04 15:33:30  dom
/* branches:  1.1.1;
/* Initial revision
/* 
/* Revision 1.1.1.1  2000/07/04 15:33:30  dom
/* First import of z88dk into the sourceforge system <gulp>
/* 
/* */

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

#include "memalloc.h"	/* before any other include to enable memory leak detection */

#include <stdio.h>
#include "config.h"
#include "z80asm.h"
#include "symbol.h"
#include "errors.h"
#include "codearea.h"

/* external functions */
enum symbols GetSym (void);
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
extern enum symbols sym, GetSym (void);
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
                  append_byte(0x02);
                  inc_PC(1);
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
            }
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          break;

        case 1:
          if (sym == comma)
            {			/* LD  (DE),A  */
              GetSym ();
              if (CheckRegister8 () == 7)
                {
                  append_byte(0x12);
                  inc_PC(1);
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
            }
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
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
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);	/* LD F,? */
        break;

      case 8:
        if (GetSym () == comma)
          {
            GetSym ();
            if (CheckRegister8 () == 7)
              {			/* LD  I,A */
                append_byte(0xED);
                append_byte(0x47);
                inc_PC(2);
              }
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
          }
        else
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
        break;

      case 9:
        if (GetSym () == comma)
          {
            GetSym ();
            if (CheckRegister8 () == 7)
              {			/* LD  R,A */
                append_byte(0xED);
                append_byte(0x4F);
                inc_PC(2);
              }
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
          }
        else
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
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
                            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                            return;
                          }
                        append_byte(0xDD);	/* LD IXl,n or LD IXh,n */
                        inc_PC(1);
                      }
                    else if (destreg & 16)
                      {
                        if ( (cpu_type & CPU_RABBIT) )
                          {
                            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                            return;
                          }
                        append_byte(0xFD);	/* LD  IYl,n or LD  IYh,n */
                        inc_PC(1);
                      }
                    destreg &= 7;
                    append_byte(destreg * 0x08 + 0x06);
                    ExprUnsigned8 (1);
                    inc_PC(2);
                    return;
                  }
                if (sourcereg == 6)
                  {
                    /* LD x, F */
                    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                    return;
                  }
                if ((sourcereg == 8) && (destreg == 7))
                  {		/* LD A,I */
                    append_byte(0xED);
                    append_byte(0x57);
                    inc_PC(2);
                    return;
                  }
                if ((sourcereg == 9) && (destreg == 7))
                  {		/* LD A,R */
                    append_byte(0xED);
                    append_byte(0x5F);
                    inc_PC(2);
                    return;
                  }
                if ((destreg & 8) || (sourcereg & 8))
                  {		/* IXl or IXh */
                    if ( (cpu_type & CPU_RABBIT) )
                      {
                        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                        return;
                      }
                    append_byte(0xDD);
                    inc_PC(1);
                  }
                else if ((destreg & 16) || (sourcereg & 16))
                  {		/* IYl or IYh */
                    if ( (cpu_type & CPU_RABBIT) )
                      {
                        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                        return;
                      }
                    append_byte(0xFD);
                    inc_PC(1);
                  }
                sourcereg &= 7;
                destreg &= 7;

                append_byte(0x40 + destreg * 0x08 + sourcereg);	/* LD  r,r  */
                inc_PC(1);
              }
          }
        else
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
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
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	  break;

	case -1:		/* LD  (HL),n  */
	  append_byte(0x36);
	  ExprUnsigned8 (1);
	  inc_PC(2);
	  break;

	default:
	  append_byte(0x70 + sourcereg);		/* LD  (HL),r  */
	  inc_PC(1);
	  break;
	}
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
}


/*
 * LD (IX|IY+d),r LD   (IX|IY+d),n
 */
void 
LD_index8bit_indrct (int destreg)
{
  int sourcereg;
  size_t opcodeptr;

  if (destreg == 5)
    append_byte(0xDD);
  else
    append_byte(0xFD);
  opcodeptr = get_codeindex();	/* pointer to instruction opcode - BUG_0015 */
  append_byte(0x36);		/* preset 2. opcode to LD (IX|IY+d),n  */


  if (!ExprSigned8 (2))
    return;			/* IX/IY offset expression */
  if (sym != rparen)
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);	/* ')' wasn't found in line */
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
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	  break;

	case -1:
	  ExprUnsigned8 (3);	/* Execute, store & patch 8bit expression for <n> */
	  inc_PC(4);
	  break;

	default:
	  patch_byte(&opcodeptr, 112 + sourcereg);		/* LD  (IX|IY+d),r  */
	  inc_PC(3);
	  break;
	}			/* end switch */
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
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
      append_byte(0x40 + destreg * 0x08 + 0x06);	/* LD   r,(HL)  */
      inc_PC(1);
      break;

    case 5:
    case 6:
      if (sourcereg == 5)
	append_byte(0xDD);
      else
	append_byte(0xFD);
      append_byte(0x40 + destreg * 0x08 + 0x06);
      ExprSigned8 (2);
      inc_PC(3);
      break;

    case 7:			/* LD  A,(nn)  */
      if (destreg == 7)
	{
	  append_byte(0x3A);
	  ExprAddress (1);
	  inc_PC(3);
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;

    case 0:
      if (destreg == 7)
	{			/* LD   A,(BC)  */
	  append_byte(0x0A);
	  inc_PC(1);
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;

    case 1:
      if (destreg == 7)
	{			/* LD   A,(DE)  */
	  append_byte(0x1A);
	  inc_PC(1);
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
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
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);	/* Right bracket missing! */
      return;
    }
  if (GetSym () == comma)
    {
      GetSym ();
      switch (sourcereg = CheckRegister16 ())
	{
	case 2:
	  append_byte(0x22);	/* LD  (nn),HL  */
	  bytepos = 1;
	  inc_PC(1);
	  break;

	case 0:
	case 1:		/* LD  (nn),dd   => dd: BC,DE,SP  */
	case 3:
	  append_byte(0xED);
	  append_byte(0x43 + sourcereg * 0x10);
	  bytepos = 2;
	  inc_PC(2);
	  break;

	case 5:		/* LD  (nn),IX    ;    LD  (nn),IY   */
	case 6:
	  if (sourcereg == 5)
	    append_byte(0xDD);
	  else
	    append_byte(0xFD);
	  append_byte(0x22);
	  bytepos = 2;
	  inc_PC(2);
	  break;

	case -1:
	  if (CheckRegister8 () == 7)
	    {
	      append_byte(0x32);	/* LD  (nn),A  */
	      inc_PC(1);
	      bytepos = 1;
	    }
	  else
	    {
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	      return;
	    }
	  break;

	default:
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	  return;
	}
    }
  else
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      return;
    }

  fseek (z80asmfile, exprptr, SEEK_SET);	/* rewind fileptr to beginning of address expression */
  GetSym ();
  ExprAddress (bytepos);	/* re-parse, evaluate, etc. */
  inc_PC(2);
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
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	      return;

	    case 2:
	      append_byte(0x2A);	/* LD   HL,(nn)  */
	      bytepos = 1;
	      inc_PC(1);
	      break;

	    case 5:		/* LD  IX,(nn)    LD  IY,(nn)  */
	    case 6:
	      if (destreg == 5)
		append_byte(0xDD);
	      else
		append_byte(0xFD);
	      append_byte(0x2A);
	      bytepos = 2;
	      inc_PC(2);
	      break;

	    default:
	      append_byte(0xED);
	      append_byte(0x4B + destreg * 0x10);
	      bytepos = 2;
	      inc_PC(2);
	      break;
	    }

	  GetSym ();
	  ExprAddress (bytepos);
	  inc_PC(2);
	}
      else
	switch (sourcereg = CheckRegister16 ())
	  {
	  case -1:		/* LD  rr,nn  */
	    switch (destreg)
	      {
	      case 4:
		ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
		return;

	      case 5:
	      case 6:
		if (destreg == 5)
		  append_byte(0xDD);
		else
		  append_byte(0xFD);
		append_byte(0x21);
		bytepos = 2;
		inc_PC(2);
		break;

	      default:
		append_byte(destreg * 0x10 + 0x01);
		bytepos = 1;
		inc_PC(1);
		break;
	      }

	    ExprAddress (bytepos);
	    inc_PC(2);
	    break;

	  case 2:
	    if (destreg == 3)
	      {			/* LD  SP,HL  */
		append_byte(0xF9);
		inc_PC(1);
	      }
	    else
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	    break;

	  case 5:		/* LD  SP,IX    LD  SP,IY  */
	  case 6:
	    if (destreg == 3)
	      {
		if (sourcereg == 5)
		  append_byte(0xDD);
		else
		  append_byte(0xFD);
		append_byte(0xF9);
		inc_PC(2);
	      }
	    else
	      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	    break;

	  default:
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	    break;
	  }
    else
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
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

