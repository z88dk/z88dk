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

Manage the code area in memory
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.h,v 1.7 2013-01-24 23:03:03 pauloscustodio Exp $ */
/* $Log: codearea.h,v $
/* Revision 1.7  2013-01-24 23:03:03  pauloscustodio
/* Replaced (unsigned char) by (byte_t)
/* Replaced (unisigned int) by (size_t)
/* Replaced (short) by (int)
/*
/* Revision 1.6  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.5  2012/11/03 17:39:35  pauloscustodio
/* astyle, comments
/*
/* Revision 1.4  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.3  2012/05/11 19:29:49  pauloscustodio
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
/* Revision 1.2  2011/10/07 17:53:04  pauloscustodio
/* BUG_0015 : Relocation issue - dubious addresses come out of linking
/* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
/* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
/* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
/* The effect was that all address calculations at link phase were considering
/*  a start offset of zero for all modules.
/* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
/* - Consequence of these two issues were all linked addresses wrong.
/*
/* Revision 1.1  2011/08/19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* */

#ifndef OBJFILE_H
#define OBJFILE_H

#include "memalloc.h"   /* before any other include */
#include "types.h"

#include <stdio.h>

/* Start the module */
extern void init_codearea_module( void );

/* move PC, return new value */
extern size_t set_PC( size_t n );
extern size_t inc_PC( size_t n );
extern size_t get_PC( void );

/* copy PC to oldPC */
extern size_t set_oldPC( void );
extern size_t get_oldPC( void );

/* init the code area, return current size */
extern void init_codearea( void );              /* set code area to zeros */
extern size_t get_codeindex( void );            /* return number of bytes appended */

extern size_t get_codesize( void );              /* size of all modules before current,
                                                   i.e. base address of current module */
extern size_t inc_codesize( size_t n );         /* increment loaded codesize */

/* write code area to an open file */
extern void fwrite_codearea( FILE *stream );
extern void fwrite_codearea_chunk( FILE *stream, size_t addr, size_t size );
extern void fread_codearea( FILE *stream, size_t size );        /* append to codearea */
extern void fread_codearea_offset( FILE *stream, size_t offset, size_t size );  /* read to codearea at offset */

/* patch a value at a position, or append to the end of the code area */
/* the patch address is incremented after store */
extern void  patch_byte( size_t *paddr, byte_t byte );   /* one byte */
extern void append_byte( byte_t byte );

extern void  patch_word( size_t *paddr, int word );             /* 2-byte word */
extern void append_word( int word );

extern void  patch_long( size_t *paddr, long dword );           /* 4-byte long */
extern void append_long( long dword );

/* get a byte at the given address */
/* the patch address is incremented after fetch */
extern byte_t get_byte( size_t *paddr );

#endif /* ndef OBJFILE_H */

