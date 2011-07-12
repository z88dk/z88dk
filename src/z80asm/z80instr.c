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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/z80instr.c,v 1.20 2011-07-12 22:47:59 pauloscustodio Exp $ */
/* $Log: z80instr.c,v $
/* Revision 1.20  2011-07-12 22:47:59  pauloscustodio
/* - Moved all error variables and error reporting code to a separate module errors.c,
/*   replaced all extern declarations of these variables by include errors.h,
/*   created symbolic constants for error codes.
/* - Added test scripts for error messages.
/*
/* Revision 1.19  2011/07/11 16:21:12  pauloscustodio
/* Removed references to dead variable 'relocfile'.
/*
/* Revision 1.18  2011/07/11 16:19:37  pauloscustodio
/* Moved all option variables and option handling code to a separate module options.c,
/* replaced all extern declarations of these variables by include options.h.
/* Created declarations in z80asm.h of objects defined in z80asm.c.
/*
/* Revision 1.17  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.16  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.15  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/* 
/* Revision 1.14  2011/07/09 01:32:27  pauloscustodio
/* added casts to clean up warnings
/* 
/* Revision 1.13  2011/02/27 11:58:46  stefano
/* Rolled back z80asm changes (I must have messed up something!!)
/* Slightly updated console output for Enterprise..
/* 
/* Revision 1.12  2011/02/25 17:14:43  stefano
/* EXOS directive fixed on z80asm
/* 
/* Revision 1.11  2011/02/23 16:27:39  stefano
/* *** empty log message ***
/* 
/* Revision 1.10  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/* 
/* Revision 1.9  2009/08/14 22:23:12  dom
/* clean up some compiler warnings
/* 
/* Revision 1.8  2009/07/18 23:23:15  dom
/* clean up the code a bit more (Formatting and a fewer magic numbers)
/* 
/* Revision 1.7  2009/05/28 19:20:16  dom
/* For the RCM SLL isn't a valid opcode, neither is anything using ixh,ixl,iyh
/* or iyl.
/* 
/* Revision 1.6  2007/06/24 14:46:24  dom
/* remove the erroneous debug line
/* 
/* Revision 1.5  2007/06/17 12:07:43  dom
/* Commit the rabbit emulation code including rrd, rld
/* 
/* Add a .vcproj for visual studio
/* 
/* Revision 1.4  2007/02/28 11:23:24  stefano
/* New platform !
/* Rabbit Control Module 2000/3000.
/* 
/* Revision 1.3  2002/01/18 16:22:11  dom
/* for add,adc,sbc the a, for 8 bit operations is optional
/* 
/* Revision 1.2  2001/01/23 10:00:09  dom
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
/* Revision 1.1  2000/07/04 15:33:29  dom
/* branches:  1.1.1;
/* Initial revision
/* 
/* Revision 1.1.1.1  2000/07/04 15:33:29  dom
/* First import of z88dk into the sourceforge system <gulp>
/* 
/* */

/* $History: Z80INSTR.C $ */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 3-10-99    Time: 12:59 */
/* Updated in $/Z80asm */
/* Change in CALLPKG():  */
/* 0 is allowed as parameter. 16 bit address 8bi split using % 256 and  / */
/* 256. */
/*  */
/* *****************  Version 12  ***************** */
/* User: Gbs          Date: 30-09-99   Time: 22:39 */
/* Updated in $/Z80asm */
/* CALL_PKG hard coded macro implemented for Garry Lancaster's Package */
/* System. */
/*  */
/* *****************  Version 10  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:07 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:31 */
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
/* User: Gbs          Date: 20-06-98   Time: 14:59 */
/* Updated in $/Z80asm */
/* SourceSafe version history comment block added. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "z80asm.h"
#include "symbol.h"
#include "options.h"
#include "errors.h"

/* external functions */
struct expr *ParseNumExpr (void);
void RemovePfixlist (struct expr *pfixexpr);
void Pass2info (struct expr *expression, char constrange, long lfileptr);
long EvalPfixExpr (struct expr *pfixexpr);
int ExprSigned8 (int listpatchoffset);
int CheckRegister8 (void);
int IndirectRegisters (void);
int CheckCondition (void);
int CheckRegister16 (void);
int ExprUnsigned8 (int listoffset);
int ExprAddress (int listoffset);
void ExtAccumulator(int opcode);
extern void SetTemporaryLine(char *line);

/* local functions */
struct JRPC *AllocJRPC (void);
void ADD_8bit_instr (void);
void ADC_8bit_instr (void);
void SBC_8bit_instr (void);
void IncDec_8bit_instr (int opcode);
void ArithLog8_instr (int opcode);
void NewJRaddr (void);
void JP_instr (int opc0, int opc);
void Subroutine_addr (int opc0, int opc);


/* global variables */
extern FILE *z80asmfile;
extern unsigned char *codeptr, *codearea;
extern long PC;
extern struct module *CURRENTMODULE;
extern enum symbols GetSym (void), sym;


void 
PushPop_instr (int opcode)
{
  int qq;

  if (GetSym () == name)
    switch (qq = CheckRegister16 ())
      {
      case REG16_BC:
      case REG16_DE:
      case REG16_HL:
        *codeptr++ = opcode + qq * 16;
        ++PC;
        break;

      case REG16_AF:
        *codeptr++ = opcode + 48;
        ++PC;
        break;

      case REG16_IX:
        *codeptr++ = 221;
        *codeptr++ = opcode + 32;
        PC += 2;
        break;

      case REG16_IY:
        *codeptr++ = 253;
        *codeptr++ = opcode + 32;
        PC += 2;
        break;

      default:
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      }
  else
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
    }
}


void 
RET (void)
{
  long constant;

  switch (GetSym ())
    {
    case name:
      if ((constant = CheckCondition ()) != -1)
        *codeptr++ = (unsigned char)(192 + constant * 8);        /* RET cc  instruction opcode */
      else
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;

    case newline:
      *codeptr++ = 201;
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      return;
    }
  ++PC;
}



void 
EX (void)
{
  if (GetSym () == lparen)
    if (GetSym () == name)
      if (CheckRegister16 () == REG16_SP)	/* EX  (SP) */
        if (GetSym () == rparen)
          if (GetSym () == comma)
            if (GetSym () == name)
              switch (CheckRegister16 ())
                {
                case REG16_HL:
                  if ( (cpu_type & CPU_RABBIT) )
                    {
                      /* Instruction code changed */
                      *codeptr++ = 0xED;
                      *codeptr++ = 0x54;
                      PC+=2;
                    }
                  else
                    {
                      *codeptr++ = 227;	/* EX  (SP),HL  */
                      ++PC;
                    }
                  break;

                case REG16_IX:
                  *codeptr++ = 221;
                  *codeptr++ = 227;	/* EX  (SP),IX  */
                  PC += 2;
                  break;

                case REG16_IY:
                  *codeptr++ = 253;
                  *codeptr++ = 227;	/* EX  (SP),IY  */
                  PC += 2;
                  break;

                default:
                  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                }
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
        else
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      else
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
    else
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
  else if (sym == name)
    {
      switch (CheckRegister16 ())
        {
        case REG16_DE:
          if (GetSym () == comma)	/* EX  DE,HL   */
            if (GetSym () == name)
              if (CheckRegister16 () == 2)
                {
                  *codeptr++ = 235;
                  ++PC;
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          break;

        case 4:
          if (GetSym () == comma)	/* EX  AF,AF'   */
            if (GetSym () == name)
              if (CheckRegister16 () == 4)
                {
                  *codeptr++ = 8;
                  ++PC;
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          break;

        default:
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
        }
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
}



void 
OUT (void)
{
  long reg;

  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      return;
    }

  if (GetSym () == lparen)
    {
      GetSym ();
      if (CheckRegister8 () == 1)
        {			/* OUT (C) */
          if (GetSym () == rparen)
            if (GetSym () == comma)
              if (GetSym () == name)
                switch (reg = CheckRegister8 ())
                  {
                  case 6:
                  case 8:
                  case 9:
                  case -1:
                    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                    break;

                  default:
                    *codeptr++ = 237;
                    *codeptr++ = (unsigned char)(65 + reg * 8);  /* OUT (C),r  */
                    PC += 2;
                    break;
                  }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
        }
      else
        {
          *codeptr++ = 211;
          if (!ExprUnsigned8 (1))
            return;
          PC += 2;
          if (sym == rparen)
            if (GetSym () == comma)
              if (GetSym () == name)
                {
                  if (CheckRegister8 () != 7)
                    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
            else
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
        }
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
}


void 
IN (void)
{
  long inreg;

  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      return;
    }
  
  if (GetSym () == name)
    {
      switch (inreg = CheckRegister8 ())
        {
        case 8:
        case 9:
        case -1:
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
          break;

        default:
          if (GetSym () != comma)
            {
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
              break;
            }
          if (GetSym () != lparen)
            {
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
              break;
            }
          GetSym ();
          switch (CheckRegister8 ())
            {
            case 1:
              *codeptr++ = 237;
              *codeptr++ = (unsigned char)(64 + inreg * 8);      /* IN r,(C) */
              PC += 2;
              break;

            case -1:
              if (inreg == 7)
                {
                  *codeptr++ = 219;
                  if (ExprUnsigned8 (1))
                    if (sym != rparen)
                      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
                  PC += 2;
                }
              else
                ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
              break;

            default:
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
              break;
            }
          break;
        }
    }
  else
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
}


void 
IM (void)
{
  long constant;
  struct expr *postfixexpr;

  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      return;
    }

  GetSym ();
  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      if (postfixexpr->rangetype & NOTEVALUABLE)
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
      else
        {
          constant = EvalPfixExpr (postfixexpr);
          switch (constant)
            {
            case 0:
              *codeptr++ = 237;
              *codeptr++ = 70;	/* IM 0   */
              break;
            case 1:
              *codeptr++ = 237;
              *codeptr++ = 86;	/* IM 1  */
              break;
            case 2:
              *codeptr++ = 237;
              *codeptr++ = 94;	/* IM 2  */
              break;
            }
          PC += 2;
        }
      RemovePfixlist (postfixexpr);	/* remove linked list, because expr. was evaluated */
    }
}


void 
RST (void)
{
  long constant;
  struct expr *postfixexpr;

  GetSym ();
  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      if (postfixexpr->rangetype & NOTEVALUABLE)
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
      else
        {
          constant = EvalPfixExpr (postfixexpr);
          if ((constant >= 0 && constant <= 56) && (constant % 8 == 0))
            {
              if ( (cpu_type & CPU_RABBIT) && 
                   ((constant == 0) || (constant == 8) || (constant == 0x30)))
                {
                  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                }
              else
                {
                  *codeptr++ = (unsigned char)(199 + constant);  /* RST  00H, ... 38H */
                  ++PC;
                }
            }
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE);
        }
      RemovePfixlist (postfixexpr);
    }
}


void 
CALLOZ (void)
{
  long constant;
  struct expr *postfixexpr;

  *codeptr++ = 231;		/* RST 20H instruction */
  ++PC;

  if (GetSym () == lparen)
    GetSym ();			/* Optional parenthesis around expression */

  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      if (postfixexpr->rangetype & NOTEVALUABLE)
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);		/* CALL_OZ expression must be evaluable */
      else
	{
	  constant = EvalPfixExpr (postfixexpr);
	  if ((constant > 0) && (constant <= 255))
	    {
              *codeptr++ = (unsigned char)constant;    /* 1 byte OZ parameter */
	      ++PC;
	    }
	  else if ((constant > 255) && (constant <= 65535))
	    {
              *codeptr++ = (unsigned char)(constant & 255);      /* 2 byte OZ parameter */
              *codeptr++ = (unsigned char)(constant >> 8);
	      PC += 2;
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE);
	}
      RemovePfixlist (postfixexpr);	/* remove linked list, because expr. was evaluated */
    }
}


void 
CALLPKG (void)
{
  long constant;
  struct expr *postfixexpr;

  *codeptr++ = 0xCF;		/* RST 08H instruction */
  ++PC;

  if (GetSym () == lparen)
    GetSym ();			/* Optional parenthesis around expression */

  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      if (postfixexpr->rangetype & NOTEVALUABLE)
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);		/* CALL_OZ expression must be evaluable */
      else
	{
	  constant = EvalPfixExpr (postfixexpr);
	  if ((constant >= 0) && (constant <= 65535))
	    {
              *codeptr++ = (unsigned char)(constant % 256);      /* 2 byte parameter always */
              *codeptr++ = (unsigned char)(constant / 256);
	      PC += 2;
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE);
	}
      RemovePfixlist (postfixexpr);	/* remove linked list, because expr. was evaluated */
    }
}

void
INVOKE (void)
{
  long constant;
  struct expr *postfixexpr;

  if (ti83plus == ON)
    *codeptr++ = 0xEF;		/* Ti83Plus: RST 28H instruction */
  else
    *codeptr++ = 0xCD;		/* Ti83: CALL */

  ++PC;

  if (GetSym () == lparen)
    GetSym ();			/* Optional parenthesis around expression */

  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      if (postfixexpr->rangetype & NOTEVALUABLE)
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);		/* INVOKE expression must be evaluable */
      else
	{
	  constant = EvalPfixExpr (postfixexpr);
	  if ((constant >= 0) && (constant <= 65535))
	    {
              *codeptr++ = (unsigned char)(constant % 256);      /* 2 byte parameter always */
              *codeptr++ = (unsigned char)(constant / 256);
	      PC += 2;
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE);
	}
      RemovePfixlist (postfixexpr);	/* remove linked list, because expr. was evaluated */
    }
}

void 
FPP (void)
{
  long constant;
  struct expr *postfixexpr;

  *codeptr++ = 223;		/* RST 18H instruction */
  ++PC;

  if (GetSym () == lparen)
    GetSym ();			/* Optional parenthesis around expression */

  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {
      if (postfixexpr->rangetype & NOTEVALUABLE)
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);		/* FPP expression must be evaluable */
      else
	{
	  constant = EvalPfixExpr (postfixexpr);
	  if ((constant > 0) && (constant < 255))
	    {
              *codeptr++ = (unsigned char)constant;    /* 1 byte OZ parameter */
	      ++PC;
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE);
	}
      RemovePfixlist (postfixexpr);	/* remove linked list, because expr. was evaluated */
    }
}


void 
Subroutine_addr (int opcode0, int opcode)
{
  long constant;
  extern enum flag EOL;

  GetSym ();
  if ((constant = CheckCondition ()) != -1) { /* Check for condition */
           
    if (GetSym () != comma) {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      return;
    }


    if (opcode0==205 && (cpu_type & CPU_RABBIT) ) 
      {
        static char buffer[200];

#if 0
        if ( constant >= 4 ) 
          {
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
            return;
          }
#endif

        switch ( constant ) {
        case FLAGS_NZ:  /* nz */
          *codeptr++ =  0x28;  /* jr z */
          *codeptr++ = 0x03;
          *codeptr++ = opcode0;           
          PC += 2;
          break;
        case FLAGS_Z:  /* z */
          *codeptr++ = 0x20;  /* jr nz */
          *codeptr++ = 0x03;
          *codeptr++ = opcode0;           
          PC += 2;
          break;
        case FLAGS_NC:  /* nc */
          *codeptr++ = 0x38;  /* jr c */
          *codeptr++ = 0x03;
          *codeptr++ = opcode0;           
          PC += 2;
          break;
        case FLAGS_C:  /* c */
          *codeptr++ = 0x30;  /* jr nc */
          *codeptr++ = 0x03;
          *codeptr++ = opcode0;           
          PC += 2;
          break;
        case FLAGS_PO:  /* po */
          *codeptr++ =  0xea; /* jp pe */
          sprintf(buffer,"ASMPC+6\n");
          SetTemporaryLine(buffer);
          GetSym();
          ExprAddress (1);
          EOL = OFF;
          *codeptr++ = 205;
          PC += 3;
          break;
        case FLAGS_PE:  /* pe */
          *codeptr++ = 0xe2; /* jp po */
          sprintf(buffer,"ASMPC+6\n");
          SetTemporaryLine(buffer);
          GetSym();
          ExprAddress (1);
          EOL = OFF;
          *codeptr++ = 205;
          PC += 3;
          break;
        case FLAGS_P:  /* p */
          *codeptr++ =  0xfa; /* jp m */
          sprintf(buffer,"ASMPC+6\n");
          SetTemporaryLine(buffer);
          GetSym();
          ExprAddress (1);
          EOL = OFF;
          *codeptr++ = 205;
          PC += 3;
          break;
        case FLAGS_M:  /* m */
          *codeptr++ = 0xf2; /* jp p */
          sprintf(buffer,"ASMPC+6\n");
          SetTemporaryLine(buffer);
          GetSym();
          ExprAddress (1);
          EOL = OFF;
          *codeptr++ = 205;
          PC += 3;
          break;
        }
      } else {
      *codeptr++ = (unsigned char)(opcode + constant * 8);       /* get instruction opcode */
    }
    GetSym();
  } else {
    *codeptr++ = opcode0;	/* JP nn, CALL nn */
  }
  ExprAddress (1);
  PC += 3;
}


void 
JP_instr (int opc0, int opc)
{
  long startexpr;		/* file pointer to start of address expression */

  startexpr = ftell (z80asmfile);	/* remember position of possible start of expression */
  if (GetSym () == lparen)
    {
      GetSym ();
      switch (CheckRegister16 ())
	{
	case 2:		/* JP (HL) */
	  *codeptr++ = 233;
	  ++PC;
	  break;

	case 5:		/* JP (IX) */
	  *codeptr++ = 221;
	  *codeptr++ = 233;
	  PC += 2;
	  break;

	case 6:		/* JP (IY) */
	  *codeptr++ = 253;
	  *codeptr++ = 233;
	  PC += 2;
	  break;

	case -1:
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	  break;

	default:
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	  break;
	}
    }
  else
    {
      fseek (z80asmfile, startexpr, SEEK_SET);	/* no indirect register were found, reparse line after 'JP' */
      Subroutine_addr (opc0, opc);	/* base opcode for <instr> nn; <instr> cc, nn */
    }
}


void 
JR (void)
{
  struct expr *postfixexpr;
  long constant;

  if (GetSym () == name)
    {
      switch (constant = CheckCondition ())
        {			/* check for a condition */
        case FLAGS_NZ:
        case FLAGS_Z:
        case FLAGS_NC:
        case FLAGS_C:
          *codeptr++ = (unsigned char)(32 + constant * 8);
          if (GetSym () == comma)
            {
              GetSym ();	/* point at start of address expression */
              break;
            }
          else
            {
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);	/* comma missing */
              return;
            }

        case -1:
          *codeptr++ = 24;	/* opcode for JR  e */
          break;		/* identifier not a condition id - check for legal expression */

        default:
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);	/* illegal condition, syntax
                                                                     * error  */
          return;
        }
    }
  PC += 2;			/* assembler PC points at next instruction */
  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {				/* get numerical expression */
      if (postfixexpr->rangetype & NOTEVALUABLE)
        {
          NewJRaddr ();		/* Amend another JR PC address to the list */
          Pass2info (postfixexpr, RANGE_JROFFSET, 1);
          ++codeptr;		/* update code pointer */
        }
      else
        {
          constant = EvalPfixExpr (postfixexpr);
          constant -= PC;
          RemovePfixlist (postfixexpr);		/* remove linked list - expression evaluated. */
          if ((constant >= -128) && (constant <= 127))
            *codeptr++ = (unsigned char)(constant);      /* opcode is stored, now store relative jump */
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_RANGE);
        }
    }
}


void 
DJNZ (void)
{
  struct expr *postfixexpr;
  long constant;

  *codeptr++ = 16;		/* DJNZ opcode */

  if (GetSym () == comma)
    {
      GetSym ();			/* optional comma */
    }

  PC += 2;
  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {				/* get numerical expression */
      if (postfixexpr->rangetype & NOTEVALUABLE)
        {
          NewJRaddr ();		/* Amend another JR PC address to the list */
          Pass2info (postfixexpr, RANGE_JROFFSET, 1);
          ++codeptr;		/* update code pointer */
        }
      else
        {
          constant = EvalPfixExpr (postfixexpr);
          constant -= PC;
          RemovePfixlist (postfixexpr);		/* remove linked list - expression evaluated. */
          if ((constant >= -128) && (constant <= 127))
            *codeptr++ = (unsigned char)(constant);      /* opcode is stored, now store relative jump */
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_RANGE);
        }
    }
}


void 
NewJRaddr (void)
{
  struct JRPC *newJRPC;

  if ((newJRPC = AllocJRPC ()) == NULL)
    {
      ReportError (NULL, 0, ERR_NO_MEMORY);
      return;
    }
  else
    {
      newJRPC->nextref = NULL;
      newJRPC->PCaddr = (unsigned short)PC;
    }

  if (CURRENTMODULE->JRaddr->firstref == NULL)
    {				/* no list yet */
      CURRENTMODULE->JRaddr->firstref = newJRPC;	/* initialise first reference */
      CURRENTMODULE->JRaddr->lastref = newJRPC;
    }
  else
    {
      CURRENTMODULE->JRaddr->lastref->nextref = newJRPC;	/* update last entry with new entry */
      CURRENTMODULE->JRaddr->lastref = newJRPC;		/* point to new entry */
    }
}


struct JRPC *
AllocJRPC (void)
{
  return (struct JRPC *) malloc (sizeof (struct JRPC));		/* allocate new JR PC address */
}


void 
ADD (void)
{
  int acc16, reg16;
  long fptr;

  fptr = ftell (z80asmfile);

  GetSym ();
  switch (acc16 = CheckRegister16 ())
    {
    case -1:
      fseek (z80asmfile, fptr, SEEK_SET);
      ExtAccumulator(0);        /* 16 bit register wasn't found - try to evaluate the 8 bit version */
      break;

    case 2:
      if (GetSym () == comma)
        {
          GetSym ();
          reg16 = CheckRegister16 ();
          if (reg16 >= 0 && reg16 <= 3)
            {
              *codeptr++ = 9 + 16 * reg16;	/* ADD HL,rr */
              ++PC;
            }
          else
            ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
        }
      else
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      break;

    case 5:
    case 6:
      if (GetSym () == comma)
        {
          GetSym ();
          reg16 = CheckRegister16 ();
          switch (reg16)
            {
            case 0:
            case 1:
            case 3:
              break;

            case 5:
            case 6:
              if (acc16 == reg16)
                reg16 = 2;
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
          if (acc16 == 5)
            *codeptr++ = 221;
          else
            *codeptr++ = 253;
          *codeptr++ = 9 + 16 * reg16;
          PC += 2;
        }
      else
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_UNKNOWN_IDENT);
      break;
    }
}


void 
SBC (void)
{
  int reg16;
  long fptr;

  fptr = ftell (z80asmfile);
  GetSym ();
  switch (CheckRegister16 ())
    {
    case -1:
      fseek (z80asmfile, fptr, SEEK_SET);
      ExtAccumulator(3);        /* 16 bit register wasn't found - try to evaluate the 8 bit version */
      break;

    case 2:
      if (GetSym () == comma)
	{
	  GetSym ();
	  reg16 = CheckRegister16 ();
	  if (reg16 >= 0 && reg16 <= 3)
	    {
	      *codeptr++ = 237;
	      *codeptr++ = 66 + 16 * reg16;
	      PC += 2;
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;
    }
}


void 
ADC (void)
{
  int reg16;
  long fptr;

  fptr = ftell (z80asmfile);

  GetSym ();
  switch (CheckRegister16 ())
    {
    case -1:
      fseek (z80asmfile, fptr, SEEK_SET);
      ExtAccumulator(1);        /* 16 bit register wasn't found - try to evaluate the 8 bit version */
      break;

    case 2:
      if (GetSym () == comma)
	{
	  GetSym ();
	  reg16 = CheckRegister16 ();
	  if (reg16 >= 0 && reg16 <= 3)
	    {
	      *codeptr++ = 237;
	      *codeptr++ = 74 + 16 * reg16;
	      PC += 2;
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	}
      else
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
      break;

    default:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;
    }
}






void 
ArithLog8_instr (int opcode)
{
  long reg;

  if (GetSym () == lparen)
    switch (reg = IndirectRegisters ())
      {
      case 2:
        *codeptr++ = 128 + opcode * 8 + 6;	/* xxx  A,(HL) */
        ++PC;
        break;

      case 5:			/* xxx A,(IX+d) */
      case 6:
        if (reg == 5)
          *codeptr++ = 221;
        else
          *codeptr++ = 253;	/* xxx A,(IY+d) */
        *codeptr++ = 128 + opcode * 8 + 6;
        ExprSigned8 (2);
        PC += 3;
        break;

      default:
        ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
        break;
      }
  else
    {				/* no indirect addressing, try to get an 8bit register */
      reg = CheckRegister8 ();
      switch (reg)
        {
          /* 8bit register wasn't found, try to evaluate an expression */
        case -1:
          *codeptr++ = 192 + opcode * 8 + 6;	/* xxx  A,n */
          ExprUnsigned8 (1);
          PC += 2;
          break;

        case 6:		/* xxx A,F illegal */
        case 8:		/* xxx A,I illegal */
        case 9:		/* xxx A,R illegal */
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
          break;

        default:
          if (reg & 8)
            {			/* IXl or IXh */
              if ( (cpu_type & CPU_RABBIT) )
                {
                  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                  return;
                }
              *codeptr++ = 221;
              ++PC;
            }
          else if (reg & 16)
            {			/* IYl or IYh */
              if ( (cpu_type & CPU_RABBIT) )
                {
                  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
                  return;
                }
              *codeptr++ = 253;
              ++PC;
            }
          reg &= 7;

          *codeptr++ = (unsigned char)(128 + opcode * 8 + reg);  /* xxx  A,r */
          ++PC;
          break;
        }
    }
}



void 
INC (void)
{
  int reg16;

  GetSym ();
  switch (reg16 = CheckRegister16 ())
    {
    case -1:
      IncDec_8bit_instr (4);	/* 16 bit register wasn't found - try to evaluate the 8bit version */
      break;

    case 4:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;

    case 5:
      *codeptr++ = 221;
      *codeptr++ = 35;
      PC += 2;
      break;

    case 6:
      *codeptr++ = 253;
      *codeptr++ = 35;
      PC += 2;
      break;

    default:
      *codeptr++ = 3 + reg16 * 16;
      ++PC;
      break;
    }
}


void 
DEC (void)
{
  int reg16;

  GetSym ();
  switch (reg16 = CheckRegister16 ())
    {
    case -1:
      IncDec_8bit_instr (5);	/* 16 bit register wasn't found - try to evaluate the 8bit version */
      break;

    case 4:
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
      break;

    case 5:
      *codeptr++ = 221;
      *codeptr++ = 43;
      PC += 2;
      break;

    case 6:
      *codeptr++ = 253;
      *codeptr++ = 43;
      PC += 2;
      break;

    default:
      *codeptr++ = 11 + reg16 * 16;
      ++PC;
      break;
    }
}


void 
IncDec_8bit_instr (int opcode)
{
  long reg;

  if (sym == lparen)
    {
      switch (reg = IndirectRegisters ())
        {
        case 2:
          *codeptr++ = 48 + opcode;	/* INC/DEC (HL) */
          ++PC;
          break;

        case 5:		/* INC/DEC (IX+d) */
        case 6:
          if (reg == 5)
            *codeptr++ = 221;
          else
            *codeptr++ = 253;	/* INC/DEC (IY+d) */
          *codeptr++ = 48 + opcode;
          ExprSigned8 (2);
          PC += 3;
          break;


        default:
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
          break;
        }
    }
  else
    {				/* no indirect addressing, try to get an 8bit register */
      reg = CheckRegister8 ();
      switch (reg)
        {
        case 6:
        case 8:
        case 9:
          ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);	/* INC/DEC I ;  INC/DEC R
                                                                     * illegal */
          break;
        case 12:
        case 13:
          if ( (cpu_type & CPU_RABBIT) )
            {
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
              return;
            }
          *codeptr++ = 221;
          *codeptr++ = (unsigned char)((reg & 7) * 8 + opcode);  /* INC/DEC  ixh,ixl */
          PC += 2;
          break;

        case 20:
        case 21:
          if ( (cpu_type & CPU_RABBIT) )
            {
              ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
              return;
            }
          *codeptr++ = 253;
          *codeptr++ = (unsigned char)((reg & 7) * 8 + opcode);  /* INC/DEC  iyh,iyl */
          PC += 2;
          break;

        default:
          *codeptr++ = (unsigned char)(reg * 8 + opcode);        /* INC/DEC  r */
          ++PC;
          break;
        }
    }
}



void 
BitTest_instr (int opcode)
{
  long bitnumber, reg;
  struct expr *postfixexpr;

  GetSym ();
  if ((postfixexpr = ParseNumExpr ()) != NULL)
    {				/* Expression must not be stored in object file */
      if (postfixexpr->rangetype & NOTEVALUABLE)
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_NOT_DEFINED);
	}
      else
	{
	  bitnumber = EvalPfixExpr (postfixexpr);
	  if (bitnumber >= 0 && bitnumber <= 7)
	    {			/* bit 0 - 7 */
	      if (sym == comma)
		{
		  if (GetSym () == lparen)
		    {
		      switch ((reg = IndirectRegisters ()))
			{
			case 2:
			  *codeptr++ = 203;	/* (HL)  */
                          *codeptr++ = (unsigned char)(opcode + bitnumber * 8 + 6);
			  PC += 2;
			  break;

			case 5:
			case 6:
			  if (reg == 5)
			    *codeptr++ = 221;
			  else
			    *codeptr++ = 253;
			  *codeptr++ = 203;
			  ExprSigned8 (2);
                          *codeptr++ = (unsigned char)(opcode + bitnumber * 8 + 6);
			  PC += 4;
			  break;

			default:
			  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
			  break;
			}
		    }
		  else
		    {		/* no indirect addressing, try to get an 8bit register */
		      reg = CheckRegister8 ();
		      switch (reg)
			{
			case 6:
			case 8:
			case 9:
			case -1:
			  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
			  break;

			default:
			  *codeptr++ = 203;
                          *codeptr++ = (unsigned char)(opcode + bitnumber * 8 + reg);
			  PC += 2;
			}
		    }
		}
	      else
		ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	    }
	  else
	    ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_INT_RANGE);
	}
      RemovePfixlist (postfixexpr);
    }
}


void 
RotShift_instr (int opcode)
{
  long reg;

  if (GetSym () == lparen)
    switch ((reg = IndirectRegisters ()))
      {
      case 2:
	*codeptr++ = 203;
	*codeptr++ = opcode * 8 + 6;
	PC += 2;
	break;

      case 5:
      case 6:
	if (reg == 5)
	  *codeptr++ = 221;
	else
	  *codeptr++ = 253;
	*codeptr++ = 203;
	ExprSigned8 (2);
	*codeptr++ = opcode * 8 + 6;
	PC += 4;
	break;

      default:
	ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_SYNTAX);
	break;
      }
  else
    {				/* no indirect addressing, try to get an 8bit register */
      reg = CheckRegister8 ();
      switch (reg)
	{
	case 6:
	case 8:
	case 9:
	case -1:
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, ERR_ILLEGAL_IDENT);
	  break;

	default:
	  *codeptr++ = 203;
          *codeptr++ = (unsigned char)(opcode * 8 + reg);
	  PC += 2;
	}
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
