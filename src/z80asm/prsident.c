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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsident.c,v 1.5 2002-05-11 20:09:38 dom Exp $ */
/* $History: PRSIDENT.C $ */
/*  */
/* *****************  Version 14  ***************** */
/* User: Gbs          Date: 30-01-00   Time: 12:51 */
/* Updated in $/Z80asm */
/* Bug fix from v1.0.14 where IF, ELSE & ENDIF id's were wrong in  */
/* ParseIdent () due to new CALL_PKG pseudo macro. */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 30-09-99   Time: 22:39 */
/* Updated in $/Z80asm */
/* CALL_PKG hard coded macro implemented for Garry Lancaster's Package */
/* System. */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:06 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:13 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 7  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:30 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:13 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:04 */
/* Updated in $/Z80asm */
/* SUB, AND, OR, XOR and CP instruction improved with alternative syntax: */
/* "<instr> [A,]xxx", allowing for specification of accumulator. This */
/* makes all accumulator related instructions equal in syntax and removes */
/* ambiguity. */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "config.h"
#include "symbol.h"


/* external functions */
void Skipline (FILE *fptr);
void ReportError (char *filename, short linenr, int errnum);
void Subroutine_addr (int opc0, int opc);
void JP_instr (int opc0, int opc);
void PushPop_instr (int opcode);
void RotShift_instr (int opcode);
void BitTest_instr (int opcode);
void ArithLog8_instr (int opcode);
void DeclSymGlobal (char *identifier, unsigned char libtype);
void DeclSymExtern (char *identifier, unsigned char libtype);
void DeclModuleName (void);
void DefSym (void);
void ifstatement (enum flag interpret);
void DEFVARS (void), DEFS (void), ORG (void), IncludeFile (void), BINARY (void), CALLOZ (void), CALLPKG (void), FPP (void);
void ADC (void), ADD (void), DEC (void), IM (void), IN (void), INC (void), INVOKE (void);
void JR (void), LD (void), OUT (void), RET (void), SBC (void);
void DEFB (void), DEFC (void), DEFM (void), DEFW (void), DEFL (void);
void RST (void), DEFGROUP (void);
long GetConstant(char *);
int CheckRegister8 (void);
void UnDefineSym(void);


/* local functions */
void ParseIdent (enum flag interpret);
void AND (void), BIT (void), CALL (void), CCF (void), CP (void), CPD (void);
void CPDR (void), CPI (void), CPIR (void), CPL (void), DAA (void);
void DI (void), DJNZ (void);
void EI (void), EX (void), EXX (void), HALT (void);
void IND (void);
void INDR (void), INI (void), INIR (void), JP (void);
void LDD (void), LDDR (void);
void LDI (void), LDIR (void), NEG (void), NOP (void), OR (void), OTDR (void), OTIR (void);
void OUTD (void), OUTI (void), POP (void), PUSH (void), RES (void);
void RETI (void), RETN (void);
void RL (void), RLA (void), RLC (void), RLCA (void), RLD (void), RR (void), RRA (void), RRC (void);
void RRCA (void), RRD (void);
void SCF (void), SET (void), SLA (void), SLL (void), SRA (void);
void SRL (void), SUB (void), XOR (void);
void DeclExternIdent (void), DeclGlobalIdent (void), ListingOn (void), ListingOff (void);
void DeclLibIdent (void), DeclGlobalLibIdent (void);
void IFstat (void), ELSEstat (void), ENDIFstat (void);
void DeclModule (void);
void LINE (void);


/* global variables */
extern FILE *z80asmfile;
extern enum symbols sym, GetSym (void);
extern enum flag listing, writeline, listing_CPY, EOL;
extern char ident[], line[];
extern long PC;
extern unsigned char *codeptr;
extern struct module *CURRENTMODULE;
extern long clineno;

typedef void (*ptrfunc) (void);	/* ptr to function returning void */
typedef int (*fptr) (const void *, const void *);

struct Z80sym
  {
    char *z80mnem;
    ptrfunc z80func;
  };


struct Z80sym Z80ident[] = {
 {"ADC", ADC},			/* 0 */
 {"ADD", ADD},
 {"AND", AND},
 {"BINARY", BINARY},
 {"BIT", BIT},
 {"CALL", CALL},		/* 5 */
 {"CALL_OZ", CALLOZ},
 {"CALL_PKG", CALLPKG},
 {"CCF", CCF},
 {"CP", CP},
 {"CPD", CPD},			/* 10 */
 {"CPDR", CPDR},		
 {"CPI", CPI},
 {"CPIR", CPIR},
 {"CPL", CPL},
 {"DAA", DAA},			/* 15 */
 {"DEC", DEC},			
 {"DEFB", DEFB},
 {"DEFC", DEFC},
 {"DEFGROUP", DEFGROUP},
 {"DEFINE", DefSym},		/* 20 */
 {"DEFL", DEFL},		
 {"DEFM", DEFM},
 {"DEFS", DEFS},
 {"DEFVARS", DEFVARS},	
 {"DEFW", DEFW},		/* 25 */
 {"DI", DI},			
 {"DJNZ", DJNZ},
 {"EI", EI},
 {"ELSE", ELSEstat},
 {"ENDIF", ENDIFstat},		/* 30 */
 {"EX", EX},			
 {"EXX", EXX},
 {"FPP", FPP},
 {"HALT", HALT},
 {"IF", IFstat},		/* 35 */
 {"IM", IM},			
 {"IN", IN},
 {"INC", INC},
 {"INCLUDE", IncludeFile},
 {"IND", IND},			/* 40 */
 {"INDR", INDR},
 {"INI", INI},
 {"INIR", INIR},
 {"INVOKE", INVOKE},
 {"JP", JP},			/* 45 */
 {"JR", JR},
 {"LD", LD},
 {"LDD", LDD},
 {"LDDR", LDDR},
 {"LDI", LDI},			/* 50 */
 {"LDIR", LDIR},
 {"LIB", DeclLibIdent},
 {"LINE", LINE},
 {"LSTOFF", ListingOff},
 {"LSTON", ListingOn},		/* 55 */
 {"MODULE", DeclModule},
 {"NEG", NEG},
 {"NOP", NOP},
 {"OR", OR},
 {"ORG", ORG},			/* 60 */
 {"OTDR", OTDR},
 {"OTIR", OTIR},
 {"OUT", OUT},
 {"OUTD", OUTD},
 {"OUTI", OUTI},		/* 65 */		
 {"POP", POP},
 {"PUSH", PUSH},
 {"RES", RES},
 {"RET", RET},
 {"RETI", RETI},		/* 70 */
 {"RETN", RETN},
 {"RL", RL},
 {"RLA", RLA},
 {"RLC", RLC},
 {"RLCA", RLCA},		/* 75 */
 {"RLD", RLD},
 {"RR", RR},
 {"RRA", RRA},
 {"RRC", RRC},
 {"RRCA", RRCA},		/* 80 */
 {"RRD", RRD},
 {"RST", RST},
 {"SBC", SBC},
 {"SCF", SCF},
 {"SET", SET},			/* 85 */
 {"SLA", SLA},
 {"SLL", SLL},
 {"SRA", SRA},
 {"SRL", SRL},
 {"SUB", SUB},			/* 90 */
 {"UNDEFINE",UnDefineSym},
 {"XDEF", DeclGlobalIdent},
 {"XLIB", DeclGlobalLibIdent},
 {"XOR", XOR},
 {"XREF", DeclExternIdent}
};

size_t totalz80id = 96;


int 
idcmp (const char *idptr, const struct Z80sym *symptr)
{
  return strcmp (idptr, symptr->z80mnem);
}


int 
SearchId (void)
{
  struct Z80sym *foundsym;

  foundsym = (struct Z80sym *) bsearch (ident, Z80ident, totalz80id, sizeof (struct Z80sym), (fptr) idcmp);

  if (foundsym == NULL)
    return -1;
  else
    return foundsym - Z80ident;
}



void 
ParseIdent (enum flag interpret)
{
  int id;

  if ((id = SearchId ()) == -1 && interpret == ON) {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 10);
  } else
    {
      switch (id)
	{
	case 35:		/* IF */
	  if (interpret == OFF)
	    Skipline (z80asmfile);	/* skip current line until EOL */
	  ifstatement (interpret);
	  break;

	case 29:		/* ELSE */
	case 30:		/* ENDIF */
	  (Z80ident[id].z80func) ();	
	  Skipline (z80asmfile);
	  break;

	default:
	  if (interpret == ON)
            {
	      (Z80ident[id].z80func) ();
            }
	  Skipline (z80asmfile);		/* skip current line until EOL */
	}
    }
}



void 
ListingOn (void)
{
  if (listing_CPY == ON)
    {
      listing = ON;		/* switch listing ON again... */
      writeline = OFF;		/* but don't write this line in listing file */
      line[0] = '\0';
    }
}



void 
ListingOff (void)
{
  if (listing_CPY == ON)
    {
      listing = writeline = OFF;	/* but don't write this line in listing file */
      line[0] = '\0';
    }
}

/* Function for Line number in C source */

void LINE(void)
{
	char	err;
	GetSym();
	clineno=GetConstant(&err);
	line[0]='\0';

}




/* dummy function - not used */
void 
IFstat (void)
{
}




void 
ELSEstat (void)
{
  sym = elsestatm;
  writeline = OFF;		/* but don't write this line in listing file */
}




void 
ENDIFstat (void)
{
  sym = endifstatm;
  writeline = OFF;		/* but don't write this line in listing file */
}



void 
DeclGlobalIdent (void)
{
  do
    {
      if (GetSym () == name)
	DeclSymGlobal (ident, 0);
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
	  return;
	}
    }
  while (GetSym () == comma);

  if (sym != newline)
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
}



void 
DeclGlobalLibIdent (void)
{
  if (GetSym () == name)
    {
      DeclModuleName ();	/* XLIB name is implicit MODULE name */
      DeclSymGlobal (ident, SYMDEF);
    }
  else
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
      return;
    }
}



void 
DeclExternIdent (void)
{
  do
    {
      if (GetSym () == name)
	DeclSymExtern (ident, 0);	/* Define symbol as extern */
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
	  return;
	}
    }
  while (GetSym () == comma);

  if (sym != newline)
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
}



void 
DeclLibIdent (void)
{
  do
    {
      if (GetSym () == name)
	DeclSymExtern (ident, SYMDEF);	/* Define symbol as extern LIB reference */
      else
	{
	  ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
	  return;
	}
    }
  while (GetSym () == comma);

  if (sym != newline)
    ReportError (CURRENTFILE->fname, CURRENTFILE->line, 1);
}



void 
DeclModule (void)
{
  GetSym ();
  DeclModuleName ();
}


void 
NOP (void)
{
  *codeptr++ = 0;
  ++PC;
}



void 
HALT (void)
{
  *codeptr++ = 118;
  ++PC;
}



void 
LDI (void)
{
  *codeptr++ = 237;
  *codeptr++ = 160;
  PC += 2;
}



void 
LDIR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 176;
  PC += 2;
}



void 
LDD (void)
{
  *codeptr++ = 237;
  *codeptr++ = 168;
  PC += 2;
}



void 
LDDR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 184;
  PC += 2;
}



void 
CPI (void)
{
  *codeptr++ = 237;
  *codeptr++ = 161;
  PC += 2;
}



void 
CPIR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 177;
  PC += 2;
}



void 
CPD (void)
{
  *codeptr++ = 237;
  *codeptr++ = 169;
  PC += 2;
}



void 
CPDR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 185;
  PC += 2;
}



void 
IND (void)
{
  *codeptr++ = 237;
  *codeptr++ = 170;
  PC += 2;
}



void 
INDR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 186;
  PC += 2;
}



void 
INI (void)
{
  *codeptr++ = 237;
  *codeptr++ = 162;
  PC += 2;
}



void 
INIR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 178;
  PC += 2;
}



void 
OUTI (void)
{
  *codeptr++ = 237;
  *codeptr++ = 163;
  PC += 2;
}



void 
OUTD (void)
{
  *codeptr++ = 237;
  *codeptr++ = 171;
  PC += 2;
}



void 
OTIR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 179;
  PC += 2;
}



void 
OTDR (void)
{
  *codeptr++ = 237;
  *codeptr++ = 187;
  PC += 2;
}




/*
 * Allow specification of "<instr> [A,]xxx"
 * in SUB, AND, OR, XOR, CP instructions
 */
void 
ExtAccumulator (int opcode)
{
  long fptr;

  fptr = ftell (z80asmfile);

  if (GetSym () == name)
    {
      if (CheckRegister8 () == 7)
	{
	  if (GetSym () == comma)
	    {
	      /* <instr> A, ... */
	      ArithLog8_instr (opcode);

	      return;
	    }
	}
    }

  /* reparse and code generate (if possible) */
  sym = nil;
  EOL = OFF;

  fseek (z80asmfile, fptr, SEEK_SET);
  ArithLog8_instr (opcode);
}



void 
CP (void)
{
  ExtAccumulator (7);
}




void 
AND (void)
{
  ExtAccumulator (4);
}



void 
OR (void)
{
  ExtAccumulator (6);
}



void 
XOR (void)
{
  ExtAccumulator (5);
}


void 
SUB (void)
{
  ExtAccumulator (2);
}




void 
SET (void)
{
  BitTest_instr (192);
}



void 
RES (void)
{
  BitTest_instr (128);
}



void 
BIT (void)
{
  BitTest_instr (64);
}



void 
RLC (void)
{
  RotShift_instr (0);
}



void 
RRC (void)
{
  RotShift_instr (1);
}



void 
RL (void)
{
  RotShift_instr (2);
}



void 
RR (void)
{
  RotShift_instr (3);
}



void 
SLA (void)
{
  RotShift_instr (4);
}



void 
SRA (void)
{
  RotShift_instr (5);
}



void 
SLL (void)
{
  RotShift_instr (6);
}



void 
SRL (void)
{
  RotShift_instr (7);
}



void 
CPL (void)
{
  *codeptr++ = 47;
  ++PC;
}



void 
RLA (void)
{
  *codeptr++ = 23;
  ++PC;
}



void 
RRA (void)
{
  *codeptr++ = 31;
  ++PC;
}



void 
RRCA (void)
{
  *codeptr++ = 15;
  ++PC;
}



void 
RLCA (void)
{
  *codeptr++ = 7;
  ++PC;
}



void 
EXX (void)
{
  *codeptr++ = 217;
  ++PC;
}



void 
PUSH (void)
{
  PushPop_instr (197);
}



void 
POP (void)
{
  PushPop_instr (193);
}




void 
RETI (void)
{
  *codeptr++ = 237;
  *codeptr++ = 77;
  PC += 2;
}



void 
RETN (void)
{
  *codeptr++ = 237;
  *codeptr++ = 69;
  PC += 2;
}



void 
RLD (void)
{
  *codeptr++ = 237;
  *codeptr++ = 111;
  PC += 2;
}



void 
RRD (void)
{
  *codeptr++ = 237;
  *codeptr++ = 103;
  PC += 2;
}



void 
NEG (void)
{
  *codeptr++ = 237;
  *codeptr++ = 68;
  PC += 2;
}



void 
CALL (void)
{
  Subroutine_addr (205, 196);
}



void 
JP (void)
{
  JP_instr (195, 194);
}



void 
CCF (void)
{
  *codeptr++ = 63;
  ++PC;
}



void 
SCF (void)
{
  *codeptr++ = 55;
  ++PC;
}



void 
DI (void)
{
  *codeptr++ = 243;
  ++PC;
}



void 
EI (void)
{
  *codeptr++ = 251;
  ++PC;
}



void 
DAA (void)
{
  *codeptr++ = 39;
  ++PC;
}
