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

#include "avltree.h"    /* base symbol data structures and routines */

/* Structured data types : */

enum flag           { OFF, ON };

enum symbols        { space, strconq, dquote, squote, semicolon, comma, fullstop, lparen, lcurly, lsquare, rsquare, rcurly, rparen,
                      plus, minus, multiply, divi, mod, power, assign, bin_and, bin_or, bin_xor, less,
                      greater, log_not, constexpr, newline, lessequal, greatequal, notequal, name, number,
                      decmconst, hexconst, binconst, charconst, negated, nil,
                      ifstatm, elsestatm, endifstatm, label
                    };

struct pageref      { struct pageref     *nextref;          /* pointer to next page reference of symbol */
                      short              pagenr;            /* page number where symbol is referenced */
                    };                                      /* the first symbol node in identifies the symbol definition */

struct symref       { struct pageref     *firstref;         /* Pointer to first page number reference of symbol */
                      struct pageref     *lastref;          /* Pointer to last/current page number reference    */
                    };                                      /* NB: First reference defines creation of symbol   */

struct pfixstack    { long               stackconstant;     /* stack structure used to evaluate postfix expressions */
                      struct pfixstack   *prevstackitem;    /* pointer to previous element on stack */
                    };


struct postfixlist  { struct postfixlist *nextoperand;      /* pointer to next element in postfix expression */
                      long               operandconst;
                      enum symbols       operatortype;
                      char               *id;               /* pointer to identifier */
                      unsigned char      type;              /* type of identifier (local, global, rel. address or constant) */
                    };

struct expr         { struct expr        *nextexpr;         /* pointer to next expression */
                      struct postfixlist *firstnode;
                      struct postfixlist *currentnode;
                      unsigned char      rangetype;         /* range type of evaluated expression */
                      enum flag          stored;            /* Flag to indicate that expression has been stored to object file */
                      char               *infixexpr;        /* pointer to ASCII infix expression */
                      char               *infixptr;         /* pointer to current char in infix expression */
                      int                codepos;           /* rel. position in module code to patch (in pass 2) */
                      char               *srcfile;          /* expr. in file 'srcfile' - allocated name area deleted by ReleaseFile */
                      int                 curline;           /* expression in line of source file */
                      long               listpos;           /* position in listing file to patch (in pass 2) */
                    };

struct expression   { struct expr        *firstexpr;        /* header of list of expressions in current module */
                      struct expr        *currexpr;
                    };


struct usedfile     { struct usedfile    *nextusedfile;
                      struct sourcefile  *ownedsourcefile;
                    };

struct sourcefile   { struct sourcefile  *prevsourcefile;   /* pointer to previously parsed source file */
                      struct sourcefile  *newsourcefile;    /* pointer to new source file to be parsed */
                      struct usedfile    *usedsourcefile;   /* list of pointers to used files owned by this file */
                      long               filepointer;       /* file pointer of current source file */
                      int		line;              /* current line number of current source file */
                      char               *fname;            /* pointer to file name of current source file */
                    };

struct JRPC_Hdr     { struct JRPC        *firstref;         /* pointer to first JR address reference in list */
                      struct JRPC        *lastref;          /* pointer to last JR address reference in list */
                    };

struct JRPC         { struct JRPC        *nextref;          /* pointer to next JR address reference  */
                      unsigned short     PCaddr;            /* absolute of PC address of JR instruction  */
                    };


typedef struct node { unsigned char     type;              /* type of symbol  */
                      char              *symname;          /* pointer to symbol identifier */
                      long              symvalue;          /* value of symbol */
                      struct symref     *references;       /* pointer to all found references of symbol */
                      struct module     *owner;            /* pointer to module which ownes symbol */
                    } symbol;

struct modules      { struct module      *first;            /* pointer to first module */
                      struct module      *last;             /* pointer to current/last module */
                    };

struct module       { struct module      *nextmodule;       /* pointer to next module */
                      char               *mname;            /* pointer to string of module name */
                      long               startoffset;       /* this module's start offset from start of code buffer */
                      long               origin;            /* Address Origin of current machine code module during linking */
                      struct sourcefile  *cfile;            /* pointer to current file record */
                      avltree           *notdeclroot;       /* pointer to root of symbols not yet declared/defined */
                      avltree           *localroot;         /* pointer to root of local symbols tree */
                      struct expression  *mexpr;            /* pointer to expressions in this module */
                      struct JRPC_Hdr    *JRaddr;           /* pointer to list of JR PC addresses */
                    };

struct liblist      { struct libfile    *firstlib;          /* pointer to first library file specified from command line */
                      struct libfile    *currlib;           /* pointer to current library file specified from command line */
                    };

struct libfile      { struct libfile    *nextlib;           /* pointer to next library file in list */
                      char              *libfilename;       /* filename of library (incl. extension) */
                      long              nextobjfile;        /* file pointer to next object file in library */
                    };

struct linklist     { struct linkedmod  *firstlink;         /* pointer to first linked object module */
                      struct linkedmod  *lastlink;          /* pointer to last linked module in list */
                    };

struct linkedmod    { struct linkedmod  *nextlink;          /* pointer to next module link */
                      char              *objfilename;       /* filename of library/object file (incl. extension) */
                      long              modulestart;        /* base pointer of beginning of object module */
                      struct module     *moduleinfo;        /* pointer to main module information */
                    };


#define CURRENTFILE     CURRENTMODULE->cfile
#define ASSEMBLERPC     "ASMPC"

/* Bitmasks for symtype */
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
#define RANGE_8SIGN     2
#define RANGE_16CONST   3
#define RANGE_32SIGN    4
