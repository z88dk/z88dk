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

Copyright (C) Paulo Custodio, 2011-2013

Handle assembly listing and symbol table listing.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/listfile.h,v 1.1 2013-02-19 22:52:40 pauloscustodio Exp $ */
/* $Log: listfile.h,v $
/* Revision 1.1  2013-02-19 22:52:40  pauloscustodio
/* BUG_0030 : List bytes patching overwrites header
/* BUG_0031 : List file garbled with input lines with 255 chars
/* New listfile.c with all the listing related code
/*
/*
/* */

#ifndef LISTFILE_H
#define LISTFILE_H

#include "memalloc.h"   /* before any other include */
#include "types.h"

/* Page metrics for list file (CH_0017) */
#define PAGE_LEN		64
#define PAGE_WIDTH		122
#define COLUMN_WIDTH	32
#define HEX_DUMP_WIDTH	32

/* open the list file for writing, given the assembly source file name 
 * creates .sym or .lst depending on options -l, -s */
extern void open_list_file( char *source_file );
extern void close_list_file( BOOL keep_file );	/* remove list file if FALSE */

/* print on list-file with printf-like arguments */
extern void fprintf_list_file( char *msg, ... );

/* write a list file line - address, hex dump and assembly line */
extern void write_asmln_list_file( char *asm_line );

/* compute list file position (ftell()) for patching byte at given offset from start of line, 
   return -1 if no list file open */
extern long list_file_patch_pos( int byte_offset );
extern void list_file_patch( long patch_pos, long value, int num_bytes );

/* return current page number */
extern int get_page_nr( void );

#endif /* ndef LISTFILE_H */

