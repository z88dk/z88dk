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

Copyright (C) Paulo Custodio, 2011-2012

Wrapper module for e4c to setup compile-time defines
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/except.h,v 1.7 2012-05-26 18:33:25 pauloscustodio Exp $ */
/* $Log: except.h,v $
/* Revision 1.7  2012-05-26 18:33:25  pauloscustodio
/* Remove EarlyReturnException, FileIOException: no longer used.
/*
/* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.5  2012/05/17 14:56:23  pauloscustodio
/* New init_except() to be called at start of main(), auto cleanup atexit(), no need to call e4c_context_end()
/*
/* Revision 1.4  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.3  2011/08/18 23:27:54  pauloscustodio
/* BUG_0009 : file read/write not tested for errors
/* - In case of disk full file write fails, but assembler does not detect the error
/*   and leaves back corruped object/binary files
/* - Created new exception FileIOException and ERR_FILE_IO error.
/* - Created new functions fputc_err, fgetc_err, ... to raise the exception on error.
/*
/* Revision 1.2  2011/08/14 19:25:55  pauloscustodio
/* - New exception FatalErrorException to raise on fatal assembly errors
/*
/* Revision 1.1  2011/08/05 19:23:53  pauloscustodio
/* CH_0004 : Exception mechanism to handle fatal errors
/* Included exceptions4c 2.4, Copyright (c) 2011 Guillermo Calvo
/*
/*
/* */

#ifndef EXCEPT_H
#define EXCEPT_H

#include "memalloc.h"                   /* before any other include to enable memory leak detection */

#ifndef __NO_INLINE__
#define __NO_INLINE__                   /* gcc -O2 fails on "__extension__ inline" */
#endif

#define _E4C_FUNCTION_NAME      NULL    /* gcc -O2 fails on "__extension__ __FUNCTION__" */

#include "e4c.h"

/* initialize exceptions */
extern void init_except( void );

/* exceptions */
E4C_DECLARE_EXCEPTION( FatalErrorException );

#endif /* ndef EXCEPT_H */

