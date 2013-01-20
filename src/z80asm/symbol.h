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
Copyright (C) Paulo Custodio, 2011-2013
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symbol.h,v 1.17 2013-01-20 13:18:10 pauloscustodio Exp $ */
/* $Log: symbol.h,v $
/* Revision 1.17  2013-01-20 13:18:10  pauloscustodio
/* BUG_0024 : (ix+128) should show warning message
/* Signed integer range was wrongly checked to -128..255 instead
/* of -128..127
/*
/* Revision 1.16  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.15  2012/05/20 05:31:18  pauloscustodio
/* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
/*
/* Revision 1.14  2012/05/17 17:42:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is
/* always raised on error.
/*
/* Revision 1.13  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.12  2011/08/19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* Revision 1.11  2011/07/14 23:49:50  pauloscustodio
/*     BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced in enum symbols,
/*      causing expressions stored in object files to be wrong, e.g. VALUE-1 was stored as
/*      VALUE*1. This caused problems in expression evaluation in link phase.
/*
/* Revision 1.10  2011/07/11 16:14:47  pauloscustodio
/* Protect against multiple inclusion
/*
/* Revision 1.9  2011/07/09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.8  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.7  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.6  2011/07/09 01:38:02  pauloscustodio
/* *** empty log message ***
/*
/* Revision 1.5  2011/07/09 01:29:10  pauloscustodio
/* BUG_0001 : Error in expression during link, expression garbled - memory corruption?
/*      Simple asm program: "org 0 \n jp NN \n jp NN \n NN: \n",
/*      compile with "z80asm -t4 -b test.asm"
/*      fails with: "File 'test.asm', Module 'TEST', Syntax error in expression \n
/*                   Error in expression +¦+²+-;¾?.¹Ò¦Ò²Ù+vÝFÝVÝ^Ýx¦ Ý@ÝHÝPÝ".
/*      Problem cause: lexer GetSym() is not prepared to read '\0' bytes.
/*      When the expression is read from the OBJ file at the link phase, the '\0'
/*      at the end of the expression field is interpreted as a random separator
/*      because ssym[] contains fewer elements (27) than the separators string (28);
/*      hence in some cases the expression is parsed correctly, e.g. without -t4
/*      the program assembles correctly.
/*      If the random separator is a semicolon, GetSym() calls Skipline() to go past
/*      the comment, and reads past the end of the expression in the OBJ file,
/*      causing the parse of the next expression to fail.
/*
/* Revision 1.4  2010/04/16 17:34:37  dom
/* Make line number an int - 32768 lines isn't big enough...
/*
/* Revision 1.3  2003/10/11 15:41:04  dom
/* changes from garry
/*
/* - support for defp -> defp addr,bank
/* - square brackets can be used in expressions
/* - comma can be used in defm
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

/* $History: Z80ASM.C $ */
/*  */

#ifndef SYMBOL_H
#define SYMBOL_H

#include <stdlib.h>
#include "avltree.h"    /* base symbol data structures and routines */

/* Structured data types : */

enum flag           { OFF, ON };

/* BUG_0001 - add colon symbol */
/* BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced in enum symbols,
        causing expressions stored in object files to be wrong, e.g. VALUE-1 was stored as
        VALUE*1. This caused problems in expression evaluation in link phase. */
enum symbols        { space, strconq, dquote, squote, semicolon, comma, fullstop, lparen, lcurly, lsquare, rsquare, rcurly, rparen,
                      plus, minus, multiply, divi, mod, power, assign, bin_and, bin_or, bin_xor, less,
                      greater, log_not, constexpr, newline, lessequal, greatequal, notequal, name, number,
                      decmconst, hexconst, binconst, charconst, negated, nil,
                      ifstatm, elsestatm, endifstatm, label, colon
                    };

struct pageref
{
    struct pageref     *nextref;          /* pointer to next page reference of symbol */
    short              pagenr;            /* page number where symbol is referenced */
};                                      /* the first symbol node in identifies the symbol definition */

struct symref
{
    struct pageref     *firstref;         /* Pointer to first page number reference of symbol */
    struct pageref     *lastref;          /* Pointer to last/current page number reference    */
};                                      /* NB: First reference defines creation of symbol   */

struct pfixstack
{
    long               stackconstant;     /* stack structure used to evaluate postfix expressions */
    struct pfixstack   *prevstackitem;    /* pointer to previous element on stack */
};


struct postfixlist
{
    struct postfixlist *nextoperand;      /* pointer to next element in postfix expression */
    long               operandconst;
    enum symbols       operatortype;
    char               *id;               /* pointer to identifier */
    unsigned char      type;              /* type of identifier (local, global, rel. address or constant) */
};

struct expr
{
    struct expr        *nextexpr;         /* pointer to next expression */
    struct postfixlist *firstnode;
    struct postfixlist *currentnode;
    unsigned char      rangetype;         /* range type of evaluated expression */
    enum flag          stored;            /* Flag to indicate that expression has been stored to object file */
    char               *infixexpr;        /* pointer to ASCII infix expression */
    char               *infixptr;         /* pointer to current char in infix expression */
    size_t             codepos;           /* rel. position in module code to patch (in pass 2) */
    char               *srcfile;          /* expr. in file 'srcfile' - allocated name area deleted by ReleaseFile */
    int                 curline;           /* expression in line of source file */
    long               listpos;           /* position in listing file to patch (in pass 2) */
};

struct expression
{
    struct expr        *firstexpr;        /* header of list of expressions in current module */
    struct expr        *currexpr;
};


struct usedfile
{
    struct usedfile    *nextusedfile;
    struct sourcefile  *ownedsourcefile;
};

struct sourcefile
{
    struct sourcefile  *prevsourcefile;   /* pointer to previously parsed source file */
    struct sourcefile  *newsourcefile;    /* pointer to new source file to be parsed */
    struct usedfile    *usedsourcefile;   /* list of pointers to used files owned by this file */
    long               filepointer;       /* file pointer of current source file */
    int               line;              /* current line number of current source file */
    char               *fname;            /* pointer to file name of current source file */
};

struct JRPC_Hdr
{
    struct JRPC        *firstref;         /* pointer to first JR address reference in list */
    struct JRPC        *lastref;          /* pointer to last JR address reference in list */
};

struct JRPC
{
    struct JRPC        *nextref;          /* pointer to next JR address reference  */
    unsigned short     PCaddr;            /* absolute of PC address of JR instruction  */
};


typedef struct node
{
    unsigned char     type;              /* type of symbol  */
    char              *symname;          /* pointer to symbol identifier */
    long              symvalue;          /* value of symbol */
    struct symref     *references;       /* pointer to all found references of symbol */
    struct module     *owner;            /* pointer to module which ownes symbol */
} symbol;

struct modules
{
    struct module      *first;            /* pointer to first module */
    struct module      *last;             /* pointer to current/last module */
};

struct module
{
    struct module      *nextmodule;       /* pointer to next module */
    char               *mname;            /* pointer to string of module name */
    size_t             startoffset;       /* this module's start offset from start of code buffer */
    long               origin;            /* Address Origin of current machine code module during linking */
    struct sourcefile  *cfile;            /* pointer to current file record */
    avltree           *notdeclroot;       /* pointer to root of symbols not yet declared/defined */
    avltree           *localroot;         /* pointer to root of local symbols tree */
    struct expression  *mexpr;            /* pointer to expressions in this module */
    struct JRPC_Hdr    *JRaddr;           /* pointer to list of JR PC addresses */
};

struct liblist
{
    struct libfile    *firstlib;          /* pointer to first library file specified from command line */
    struct libfile    *currlib;           /* pointer to current library file specified from command line */
};

struct libfile
{
    struct libfile    *nextlib;           /* pointer to next library file in list */
    char              *libfilename;       /* filename of library (incl. extension) */
    long              nextobjfile;        /* file pointer to next object file in library */
};

struct linklist
{
    struct linkedmod  *firstlink;         /* pointer to first linked object module */
    struct linkedmod  *lastlink;          /* pointer to last linked module in list */
};

struct linkedmod
{
    struct linkedmod  *nextlink;          /* pointer to next module link */
    char              *objfilename;       /* filename of library/object file (incl. extension) */
    long              modulestart;        /* base pointer of beginning of object module */
    struct module     *moduleinfo;        /* pointer to main module information */
};


#define CURRENTFILE     CURRENTMODULE->cfile
#define ASSEMBLERPC     "ASMPC"

/* Bitmasks for symboltype */
#define SYMDEFINED      1                                  /* bitmask 00000001 */
#define SYMTOUCHED      2                                  /* bitmask 00000010 */
#define SYMDEF          4                                  /* bitmask 00000100 */
#define SYMADDR         8                                  /* bitmask 00001000 */
#define SYMLOCAL        16                                 /* bitmask 00010000 */
#define SYMXDEF         32                                 /* bitmask 00100000 */
#define SYMXREF         64                                 /* bitmask 01000000 */

#define XDEF_OFF        223                                /* bitmask 11011111 */
#define XREF_OFF        191                                /* bitmask 10111111 */
#define SYMLOCAL_OFF    239                                /* bitmask 11101111 */
#define SYMTYPE         120                                /* bitmask 01111000 */
#define SYM_NOTDEFINED  0

/* bitmasks for expression evaluation in rangetype */
#define RANGE           7                                  /* bitmask 00000111 */   /* Range types are 0 - 4 */
#define EXPRADDR        8                                  /* bitmask 00001000 */   /* Expression contains reloc. address label */
#define EXPRLOCAL       16                                 /* bitmask 00010000 */   /* Expression contains local symbol */
#define EXPRGLOBAL      32                                 /* bitmask 00100000 */   /* Expression contains global symbol */
#define EXPREXTERN      64                                 /* bitmask 01000000 */   /* Expression contains extern symbol */
#define NOTEVALUABLE    128                                /* bitmask 10000000 */   /* Expression is not evaluable */
#define EVALUATED       127                                /* bitmask 01111111 */   /* Expression is not evaluable */
#define CLEAR_EXPRADDR  247                                /* bitmask 11110111 */   /* Convert to constant expression */

#define RANGE_JROFFSET  0
#define RANGE_8UNSIGN   1
#define RANGE_8SIGN     2		/* (ix+d) */
#define RANGE_16CONST   3
#define RANGE_32SIGN    4


#endif /* ndef SYMBOL_H */

