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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/prsident.c,v 1.19 2011-07-09 01:46:00 pauloscustodio Exp $ */
/* $Log: prsident.c,v $
/* Revision 1.19  2011-07-09 01:46:00  pauloscustodio
/* Added Log keyword
/* */

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
#include "z80asm.h"
#include "symbol.h"


/* external functions */
void Skipline (FILE *fptr);
int DefineSymbol (char *identifier, long value, unsigned char symboltype);
void ReportError (char *filename, int linenr, int errnum);
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
void DEFB (void), DEFC (void), DEFM (void), DEFW (void), DEFL (void), DEFP (void);
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
void SetTemporaryLine(char *line);

/* global variables */
extern FILE *z80asmfile;
extern enum symbols sym, GetSym (void);
extern enum flag listing, writeline, listing_CPY, EOL, sdcc_hacks, force_xlib;
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
 {"DEFP", DEFP},
 {"DEFS", DEFS},
 {"DEFVARS", DEFVARS},		/* 25 */
 {"DEFW", DEFW},
 {"DI", DI},			
 {"DJNZ", DJNZ},
 {"EI", EI},
 {"ELSE", ELSEstat},		/* 30 */
 {"ENDIF", ENDIFstat},	
 {"EX", EX},			
 {"EXX", EXX},
 {"FPP", FPP},
 {"HALT", HALT},		/* 35 */
 {"IF", IFstat},
 {"IM", IM},			
 {"IN", IN},
 {"INC", INC},
 {"INCLUDE", IncludeFile},	/* 40 */
 {"IND", IND},
 {"INDR", INDR},
 {"INI", INI},
 {"INIR", INIR},
 {"INVOKE", INVOKE},		/* 45 */
 {"JP", JP},
 {"JR", JR},
 {"LD", LD},
 {"LDD", LDD},
 {"LDDR", LDDR},		/* 50 */
 {"LDI", LDI},
 {"LDIR", LDIR},
 {"LIB", DeclLibIdent},
 {"LINE", LINE},
 {"LSTOFF", ListingOff},	/* 55 */
 {"LSTON", ListingOn},
 {"MODULE", DeclModule},
 {"NEG", NEG},
 {"NOP", NOP},
 {"OR", OR},			/* 60 */
 {"ORG", ORG},
 {"OTDR", OTDR},
 {"OTIR", OTIR},
 {"OUT", OUT},
 {"OUTD", OUTD},		/* 65 */
 {"OUTI", OUTI},
 {"OZ", CALLOZ},		
 {"POP", POP},
 {"PUSH", PUSH},
 {"RES", RES},			/* 70 */
 {"RET", RET},
 {"RETI", RETI},
 {"RETN", RETN},
 {"RL", RL},
 {"RLA", RLA},			/* 75 */
 {"RLC", RLC},
 {"RLCA", RLCA},
 {"RLD", RLD},
 {"RR", RR},
 {"RRA", RRA},			/* 80 */
 {"RRC", RRC},
 {"RRCA", RRCA},
 {"RRD", RRD},
 {"RST", RST},
 {"SBC", SBC},			/* 85 */
 {"SCF", SCF},
 {"SET", SET},
 {"SLA", SLA},
 {"SLL", SLL},
 {"SRA", SRA},			/* 90 */
 {"SRL", SRL},
 {"SUB", SUB},
 {"UNDEFINE",UnDefineSym},
 {"XDEF", DeclGlobalIdent},
 {"XLIB", DeclGlobalLibIdent},	/* 95 */
 {"XOR", XOR},
 {"XREF", DeclExternIdent}
};

size_t totalz80id = sizeof(Z80ident) / sizeof(Z80ident[0]);


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
	case 36:		/* IF */
	  if (interpret == OFF)
	    Skipline (z80asmfile);	/* skip current line until EOL */
	  ifstatement (interpret);
	  break;

	case 30:		/* ELSE */
	case 31:		/* ENDIF */
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
        char    name[128];
	GetSym();
	clineno=GetConstant(&err);
	line[0]='\0';
        snprintf(name, sizeof(name),"__C_LINE_%d",clineno);
        DefineSymbol (name, PC, SYMADDR | SYMTOUCHED);
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
  if ( sdcc_hacks == ON ) 
    {
      DeclLibIdent();
      return;
    }
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
        if (GetSym () == name) {
            DeclSymExtern (ident, SYMDEF);	/* Define symbol as extern LIB reference */
        }
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
  if ( force_xlib == ON )
    {
      DeclGlobalLibIdent();
    }
  else
    {
      GetSym ();
      DeclModuleName ();
    }
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
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

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
  if ( (cpu_type & CPU_RABBIT) )
    {
      SetTemporaryLine("\ncall rcmx_cpi\n");
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 161;
  PC += 2;
}



void 
CPIR (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      SetTemporaryLine("\ncall rcmx_cpir\n");
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 177;
  PC += 2;
}



void 
CPD (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      SetTemporaryLine("\ncall rcmx_cpd\n");
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 169;
  PC += 2;
}



void 
CPDR (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      SetTemporaryLine("\ncall rcmx_cpdr\n");
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 185;
  PC += 2;
}



void 
IND (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 170;
  PC += 2;
}



void 
INDR (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 186;
  PC += 2;
}



void 
INI (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }
  *codeptr++ = 237;
  *codeptr++ = 162;
  PC += 2;
}



void 
INIR (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 178;
  PC += 2;
}



void 
OUTI (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 163;
  PC += 2;
}



void 
OUTD (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 171;
  PC += 2;
}



void 
OTIR (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 179;
  PC += 2;
}



void 
OTDR (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

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
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }
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
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }
  *codeptr++ = 237;
  *codeptr++ = 69;
  PC += 2;
}



void 
RLD (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      SetTemporaryLine("\ncall rcmx_rld\n");
      return;
    }

  *codeptr++ = 237;
  *codeptr++ = 111;
  PC += 2;
}



void 
RRD (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      SetTemporaryLine("\ncall rcmx_rrd\n");
      return;
    }

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
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 243;
  ++PC;
}



void 
EI (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 251;
  ++PC;
}



void 
DAA (void)
{
  if ( (cpu_type & CPU_RABBIT) )
    {
      ReportError (CURRENTFILE->fname, CURRENTFILE->line, 11);
      return;
    }

  *codeptr++ = 39;
  ++PC;
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


