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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.c,v 1.12 2013-05-12 19:39:32 pauloscustodio Exp $ */
/* $Log: codearea.c,v $
/* Revision 1.12  2013-05-12 19:39:32  pauloscustodio
/* warnings
/*
/* Revision 1.11  2013/03/30 00:02:22  pauloscustodio
/* include memalloc.h before any other include
/*
/* Revision 1.10  2013/02/22 17:19:19  pauloscustodio
/* Add listfile interface to append bytes to the listing
/* Remove oldPC - no longer needed with new listfile
/* Solve memory leak
/*
/* Revision 1.9  2013/01/24 23:03:03  pauloscustodio
/* Replaced (unsigned char) by (byte_t)
/* Replaced (unisigned int) by (size_t)
/* Replaced (short) by (int)
/*
/* Revision 1.8  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.7  2012/05/26 18:51:10  pauloscustodio
/* CH_0012 : wrappers on OS calls to raise fatal error
/* CH_0013 : new errors interface to decouple calling code from errors.c
/*
/* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.5  2012/05/24 16:18:53  pauloscustodio
/* Let garbage collector do memory release atexit()
/*
/* Revision 1.4  2012/05/20 06:02:08  pauloscustodio
/* Garbage collector
/* Added automatic garbage collection on exit and simple fence mechanism
/* to detect buffer underflow and overflow, to memalloc functions.
/* No longer needed to call init_malloc().
/* No longer need to try/catch during creation of memory structures to
/* free partially created data - all not freed data is freed atexit().
/* Renamed xfree0() to xfree().
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

#include "memalloc.h"   /* before any other include */

#include <memory.h>
#include "codearea.h"
#include "config.h"
#include "errors.h"
#include "symbol.h"
#include "z80asm.h"
#include "file.h"
#include "listfile.h"

/*-----------------------------------------------------------------------------
*   global data
*----------------------------------------------------------------------------*/
static char *codearea;                  /* machine code block */
static size_t codeindex;                /* point to current address of codearea */
static size_t codesize;                 /* size of all modules before current,
                                           i.e. base address of current module
                                           BUG_0015 */
static size_t PC;		                /* Program Counter */

/*-----------------------------------------------------------------------------
*   cleanup memory on exit
*----------------------------------------------------------------------------*/
static void fini_codearea_module( void )
{
	if ( codearea != NULL )
	{
		xfree( codearea );
	}
}

/*-----------------------------------------------------------------------------
*   init_codearea_module
*       Alloc all global structures
*----------------------------------------------------------------------------*/
void init_codearea_module( void )
{
	static BOOL initialized = FALSE;

    /* allocate memory for Z80 machine code */
    codearea = (byte_t *) xcalloc( MAXCODESIZE, sizeof( char ) );
	if ( ! initialized ) 
	{
		atexit( fini_codearea_module );
		initialized = TRUE;
	}

    init_codearea();                    /* init vars */

    codesize  = 0;                      /* marks start of each new module,
                                           always incremented
                                           BUG_0015 */

}

/*-----------------------------------------------------------------------------
*   modify program counter
*----------------------------------------------------------------------------*/
size_t set_PC( size_t n )
{
    return PC = n;
}

size_t inc_PC( size_t n )
{
    return PC += n;
}

size_t get_PC( void )
{
    return PC;
}

/*-----------------------------------------------------------------------------
*   init the code area, return current size
*----------------------------------------------------------------------------*/
void init_codearea( void )
{
    codeindex = 0;                      /* where to store next opcode byte */
    set_PC( 0 );
    memset( codearea, 0, MAXCODESIZE );
}

size_t get_codeindex( void ) /* BUG_0015 */
{
    return codeindex;
}

size_t get_codesize( void ) /* BUG_0015 */
{
    return codesize;
}

size_t inc_codesize( size_t n ) /* BUG_0015 */
{
    return codesize += n;
}

static void check_space( size_t addr, size_t n )
{
    if ( addr + n > MAXCODESIZE )
    {
        fatal_error( ERR_MAX_CODESIZE, ( long )MAXCODESIZE );
    }
}

/*-----------------------------------------------------------------------------
*   read/write code area to an open file
*----------------------------------------------------------------------------*/
void fwrite_codearea( FILE *stream )
{
    fwritec_err( codearea, codeindex, stream );
}

void fwrite_codearea_chunk( FILE *stream, size_t addr, size_t size )
{
    if ( addr < codeindex )
    {
        if ( addr + size > codeindex )
        {
            size = codeindex - addr;
        }

        fwritec_err( codearea + addr, size, stream );
    }
}

/* append data read from file to the current code area */
void fread_codearea( FILE *stream, size_t size )
{
    check_space( codeindex, size );
    freadc_err( codearea + codeindex, size, stream );
    codeindex += size;
}

/* read to codearea at offset - BUG_0015 */
void fread_codearea_offset( FILE *stream, size_t offset, size_t size )
{
    check_space( offset, size );
    freadc_err( codearea + offset, size, stream );

    if ( codeindex < offset + size )
    {
        codeindex = offset + size;
    }
}


/*-----------------------------------------------------------------------------
*   load data into code area
*----------------------------------------------------------------------------*/
void patch_byte( size_t *paddr, byte_t byte )
{
    check_space( *paddr, 1 );
    codearea[( *paddr )++] = byte;
}

void append_byte( byte_t byte )
{
    patch_byte( &codeindex, byte );
	list_append_byte( byte );
}

void patch_word( size_t *paddr, int word )
{
    check_space( *paddr, 2 );
    codearea[( *paddr )++] = word & 0xFF;
    word >>= 8;
    codearea[( *paddr )++] = word & 0xFF;
    word >>= 8;
}

void append_word( int word )
{
    patch_word( &codeindex, word );
	list_append_word( word );
}

void patch_long( size_t *paddr, long dword )
{
    check_space( *paddr, 4 );
    codearea[( *paddr )++] = dword & 0xFF;
    dword >>= 8;
    codearea[( *paddr )++] = dword & 0xFF;
    dword >>= 8;
    codearea[( *paddr )++] = dword & 0xFF;
    dword >>= 8;
    codearea[( *paddr )++] = dword & 0xFF;
    dword >>= 8;
}

void append_long( long dword )
{
    patch_long( &codeindex, dword );
	list_append_long( dword );
}

byte_t get_byte( size_t *paddr )
{
    byte_t byte;

    E4C_ASSERT( *paddr < codeindex );
    byte = codearea[( *paddr )++];
    return byte;
}

