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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/symbols.h,v 1.9 2013-05-23 22:22:23 pauloscustodio Exp $ */
/* $Log: symbols.h,v $
/* Revision 1.9  2013-05-23 22:22:23  pauloscustodio
/* Move symbol to sym.c, rename to Symbol
/*
/* Revision 1.8  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.7  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.6  2012/05/20 05:31:18  pauloscustodio
/* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
/*
/* Revision 1.5  2012/05/18 00:23:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is always raised on error.
/*
/* Revision 1.4  2012/05/17 17:49:20  pauloscustodio
/* astyle
/*
/* Revision 1.3  2012/05/17 17:42:14  pauloscustodio
/* DefineSymbol() and DefineDefSym() defined as void, a fatal error is
/* always raised on error.
/*
/* Revision 1.2  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.1  2011/07/11 15:44:03  pauloscustodio
/* Created declarations in symbols.h of objects defined in symbols.c
/*
/* */

#ifndef SYMBOLS_H
#define SYMBOLS_H

#include "symbol.h"

/* Create a symbol in the local or global tree */
extern void DefineSymbol( char *identifier, long value, byte_t symboltype );

/* Create a symbol in the given tree, error if already defined */
extern void DefineDefSym( char *identifier, long value, byte_t symboltype, avltree **root );

/* Declare a global symbol */
extern void DeclSymGlobal( char *identifier, byte_t libtype );

/* Declare an external symbol */
extern void DeclSymExtern( char *identifier, byte_t libtype );

#endif /* ndef SYMBOLS_H */
