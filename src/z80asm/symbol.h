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
Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/symbol.h,v 1.31 2014-01-11 01:29:40 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "model.h"
#include "objfile.h"
#include "symtab.h"
#include "types.h"
#include <stdlib.h>

/* Structured data types : */

enum flag           { OFF, ON };

/* BUG_0001 - add colon symbol */
/* BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced in enum symbols,
        causing expressions stored in object files to be wrong, e.g. VALUE-1 was stored as
        VALUE*1. This caused problems in expression evaluation in link phase. */
enum symbols
{
#define TOKEN(name, str_legacy, str_new) name,
#include "token_def.h"
#undef TOKEN
};


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
    byte_t			   type;              /* type of identifier (local, global, rel. address or constant) */
};

struct expr
{
    struct expr        *nextexpr;         /* pointer to next expression */
    struct postfixlist *firstnode;
    struct postfixlist *currentnode;
    byte_t			   rangetype;         /* range type of evaluated expression */
    enum flag          stored;            /* Flag to indicate that expression has been stored to object file */
    char               *infixexpr;        /* pointer to ASCII infix expression */
    char               *infixptr;         /* pointer to current char in infix expression */
    size_t             codepos;           /* rel. position in module code to patch (in pass 2) */
    char               *srcfile;          /* expr. in file 'srcfile' - allocated name area deleted by ReleaseFile */
    int                curline;           /* expression in line of source file */
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
    size_t			   PCaddr;            /* absolute of PC address of JR instruction  */
};

struct modules
{
    struct module      *first;            /* pointer to first module */
    struct module      *last;             /* pointer to current/last module */
};

struct module
{
    struct module     *nextmodule;      /* pointer to next module */
    char              *mname;           /* pointer to string of module name */
    size_t             startoffset;     /* this module's start offset from start of code buffer */
    long               origin;          /* Address Origin of current machine code module during linking */
    struct sourcefile *cfile;           /* pointer to current file record */
    SymbolHash        *local_symtab;    /* pointer to root of local symbols tree */
    struct expression *mexpr;           /* pointer to expressions in this module */
    struct JRPC_Hdr   *JRaddr;          /* pointer to list of JR PC addresses */
    ObjFile			  *obj_file;		/* ObjFile structure describing the object file */
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

/* bitmasks for expression evaluation in rangetype */
#define RANGE           7		/* bitmask 00000111 */   /* Range types are 0 - 4 */
#define EXPRADDR        8       /* bitmask 00001000 */   /* Expression contains reloc. address label */
#define EXPRLOCAL       16      /* bitmask 00010000 */   /* Expression contains local symbol */
#define EXPRGLOBAL      32      /* bitmask 00100000 */   /* Expression contains global symbol */
#define EXPREXTERN      64      /* bitmask 01000000 */   /* Expression contains extern symbol */
#define NOTEVALUABLE    128     /* bitmask 10000000 */   /* Expression is not evaluable */
#define EVALUATED       127     /* bitmask 01111111 */   /* Expression is evaluated */
#define CLEAR_EXPRADDR  247     /* bitmask 11110111 */   /* Convert to constant expression */

#define RANGE_JROFFSET  0		/* relative jump argument */
#define RANGE_8UNSIGN   1		/* 8-bit immediate */
#define RANGE_8SIGN     2		/* (ix+d) */
#define RANGE_16CONST   3		/* 16-bit immediate */
#define RANGE_32SIGN    4		/* 32-bit immediate */

/* return 1, 2 or 4 for a rangetype */
#define RANGE_SIZE(x)	(((x) & RANGE) == RANGE_32SIGN  ? 4 : \
						 ((x) & RANGE) == RANGE_16CONST ? 2 : \
														  1 )

/*
* $Log: symbol.h,v $
* Revision 1.31  2014-01-11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.30  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.29  2014/01/05 23:20:39  pauloscustodio
* List, StrHash classlist and classhash receive the address of the container
* object in all functions that add items to the container, and create the
* container on first use. This allows a container to be staticaly
* initialized with NULL and instantiated on first push/unshift/set.
* Add count attribute to StrHash, classhash to count elements in container.
* Add free_data attribute in StrHash to register a free fucntion to delete
* the data container when the hash is removed or a key is overwritten.
*
* Revision 1.28  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.27  2013/08/30 01:11:54  pauloscustodio
* Symbols in symbol.h enum definition and in z80asm.c ssyms[] must be in the exact
* same order. Moreover need to define some different symbols for the legacy
* version.
*
* Move all defintions to token_def.h, included in both other files.
*
* Revision 1.26  2013/06/10 23:11:33  pauloscustodio
* CH_0023 : Remove notdecl_tab
*
* Revision 1.25  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMPC, ASMSIZE, ASMTAIL
*
* Revision 1.24  2013/06/01 01:24:22  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
*
* Revision 1.23  2013/05/16 23:39:48  pauloscustodio
* Move struct node to sym.c, rename to Symbol
* Move SymbolRef to symref.c
*
* Revision 1.22  2013/05/16 22:45:21  pauloscustodio
* Add ObjFile to struct module
* Use ObjFile to check for valid object file
*
* Revision 1.21  2013/02/26 02:11:32  pauloscustodio
* New model_symref.c with all symbol cross-reference list handling
*
* Revision 1.20  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
*
* Revision 1.19  2013/02/11 21:52:31  pauloscustodio
* Added comments
*
* Revision 1.18  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (byte_t)
* Replaced (unisigned int) by (size_t)
* Replaced (short) by (int)
*
* Revision 1.17  2013/01/20 13:18:10  pauloscustodio
* BUG_0024 : (ix+128) should show warning message
* Signed integer range was wrongly checked to -128..255 instead
* of -128..127
*
* Revision 1.16  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.15  2012/05/20 05:31:18  pauloscustodio
* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
*
* Revision 1.14  2012/05/17 17:42:14  pauloscustodio
* define_symbol() defined as void, a fatal error is
* always raised on error.
*
* Revision 1.13  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.12  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
*
* Revision 1.11  2011/07/14 23:49:50  pauloscustodio
*     BUG_0001(a) : during correction of BUG_0001, new symbol colon was introduced in enum symbols,
*      causing expressions stored in object files to be wrong, e.g. VALUE-1 was stored as
*      VALUE*1. This caused problems in expression evaluation in link phase.
*
* Revision 1.10  2011/07/11 16:14:47  pauloscustodio
* Protect against multiple inclusion
*
* Revision 1.9  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
*
* Revision 1.8  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
*
* Revision 1.7  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
*
* Revision 1.6  2011/07/09 01:38:02  pauloscustodio
* *** empty log message ***
*
* Revision 1.5  2011/07/09 01:29:10  pauloscustodio
* BUG_0001 : Error in expression during link, expression garbled - memory corruption?
*      Simple asm program: "org 0 \n jp NN \n jp NN \n NN: \n",
*      compile with "z80asm -t4 -b test.asm"
*      fails with: "File 'test.asm', Module 'TEST', Syntax error in expression \n
*                   Error in expression +¦+²+-;¾?.¹Ò¦Ò²Ù+vÝFÝVÝ^Ýx¦ Ý@ÝHÝPÝ".
*      Problem cause: lexer GetSym() is not prepared to read '\0' bytes.
*      When the expression is read from the OBJ file at the link phase, the '\0'
*      at the end of the expression field is interpreted as a random separator
*      because ssym[] contains fewer elements (27) than the separators string (28);
*      hence in some cases the expression is parsed correctly, e.g. without -t4
*      the program assembles correctly.
*      If the random separator is a semicolon, GetSym() calls Skipline() to go past
*      the comment, and reads past the end of the expression in the OBJ file,
*      causing the parse of the next expression to fail.
*
* Revision 1.4  2010/04/16 17:34:37  dom
* Make line number an int - 32768 lines isn't big enough...
*
* Revision 1.3  2003/10/11 15:41:04  dom
* changes from garry
*
* - support for defp -> defp addr,bank
* - square brackets can be used in expressions
* - comma can be used in defm
*
* Revision 1.2  2001/03/21 16:34:01  dom
* Added changes to allow labels to end in ':' and the prefix '.' isn't
* necessarily needed..this isn't guaranteed to be perfect so let me know
* of any problems and drop back to 1.0.18
*
* Revision 1.1  2000/07/04 15:33:29  dom
* branches:  1.1.1;
* Initial revision
*
* Revision 1.1.1.1  2000/07/04 15:33:29  dom
* First import of z88dk into the sourceforge system <gulp>
*
*/

