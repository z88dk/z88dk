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
Copyright (C) Paulo Custodio, 2011

Manage the code area in memory
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.h,v 1.1 2011-08-19 15:53:58 pauloscustodio Exp $ */
/* $Log: codearea.h,v $
/* Revision 1.1  2011-08-19 15:53:58  pauloscustodio
/* BUG_0010 : heap corruption when reaching MAXCODESIZE
/* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
/* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
/*
/* */

#ifndef OBJFILE_H
#define OBJFILE_H

#include "memalloc.h"			/* before any other include to enable memory leak detection */

#include <stdio.h>

/* Start the module */
extern void init_codearea_module (void);

/* move PC, return new value */
extern size_t set_PC (size_t n);
extern size_t inc_PC (size_t n);
extern size_t get_PC (void);

/* copy PC to oldPC */
extern size_t set_oldPC (void);
extern size_t get_oldPC (void);

/* init the code area, return current size */
extern void init_codearea (void);		// set code area to zeros
extern size_t get_code_size (void);		// return number of bytes appended

/* write code area to an open file */
extern void fwrite_codearea       (FILE *stream);
extern void fwrite_codearea_chunk (FILE *stream, size_t addr, size_t size);
extern void fread_codearea        (FILE *stream, size_t size);	// append to codearea

/* patch a value at a position, or append to the end of the code area */
/* the patch address is incremented after store */
extern void  patch_byte    (size_t *paddr, unsigned char byte);	// one byte
extern void append_byte    (               unsigned char byte);

extern void  patch_word    (size_t *paddr, int word);		// 2-byte word
extern void append_word    (               int word);

extern void  patch_long    (size_t *paddr, long dword);		// 4-byte long
extern void append_long    (               long dword);

/* get a byte at the given address */
/* the patch address is incremented after fetch */
extern unsigned char get_byte (size_t *paddr);

#endif /* ndef OBJFILE_H */
