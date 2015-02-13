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
Copyright (C) Paulo Custodio, 2011-2015

Global data model.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/model.h,v 1.31 2015-02-13 00:30:31 pauloscustodio Exp $
*/

#pragma once

#include "list.h"
#include "module.h"
#include "types.h"
#include "utarray.h"



/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
extern void model_init(void);

/*-----------------------------------------------------------------------------
*   Singleton interfaces
*----------------------------------------------------------------------------*/

/* interface to SrcFile singleton */
extern Bool  src_open( char *filename, UT_array *dir_list );
extern char *src_getline( void );
extern void  src_ungetline( char *lines );
extern char *src_filename( void );
extern int   src_line_nr( void );	

extern void  src_push( void );
extern Bool  src_pop( void );
