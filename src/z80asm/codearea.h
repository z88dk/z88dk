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

Manage the code area in memory

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/codearea.h,v 1.26 2014-06-09 13:15:25 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "types.h"

#include <stdio.h>

/*-----------------------------------------------------------------------------
*   Handle ASMPC
*	set_PC() defines the instruction start address
*	every byte added increments an offset but keeps ASMPC with start of opcode
*	next_PC() moves to the next opcode
*	get_opcode_size() returns current offset
*----------------------------------------------------------------------------*/
extern void set_PC( UInt n );
extern UInt next_PC( void );
extern UInt get_PC( void );
extern UInt get_opcode_size( void );

/*-----------------------------------------------------------------------------
*   reset the code area, return current size
*----------------------------------------------------------------------------*/
extern void reset_codearea( void );			/* set code area to zeros */
extern UInt get_codeindex( void );			/* return number of bytes appended */

extern UInt get_codesize( void );			/* size of all modules before current,
                                               i.e. base address of current module */
extern UInt inc_codesize( UInt n );			/* increment loaded codesize */

/*-----------------------------------------------------------------------------
*   write code area to an open file
*----------------------------------------------------------------------------*/
extern void fwrite_codearea( FILE *stream );
extern void fwrite_codearea_chunk( FILE *stream, UInt addr, UInt size );
extern void fread_codearea( FILE *stream, UInt size );		/* append to codearea */
extern void fread_codearea_offset( FILE *stream, UInt offset, UInt size );  /* read to codearea at offset */

/*-----------------------------------------------------------------------------
*   patch a value at a position, or append to the end of the code area
*	the patch address is incremented after store
*----------------------------------------------------------------------------*/
extern void  patch_byte( UInt *paddr, Byte byte1 );		/* one byte */
extern void append_byte( Byte byte1 );
extern void append_2bytes( Byte byte1, Byte byte2 );

extern void  patch_word( UInt *paddr, int word );		/* 2-byte word */
extern void append_word( int word );

extern void  patch_long( UInt *paddr, long dword );		/* 4-byte long */
extern void append_long( long dword );

/*-----------------------------------------------------------------------------
*   get a byte at the given address
*	the patch address is incremented after fetch
*----------------------------------------------------------------------------*/
extern Byte get_byte( UInt *paddr );


/*
* $Log: codearea.h,v $
* Revision 1.26  2014-06-09 13:15:25  pauloscustodio
* Int and UInt types
*
* Revision 1.25  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.24  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.23  2014/05/06 22:17:37  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.22  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.21  2014/04/22 23:52:55  pauloscustodio
* As inc_PC() is no longer needed, append_opcode() no longer makes sense.
* Removed append_opcode() and created a new helper append_2bytes().
*
* Revision 1.20  2014/04/22 23:32:42  pauloscustodio
* Release 2.2.0 with major fixes:
*
* - Object file format changed to version 03, to include address of start
* of the opcode of each expression stored in the object file, to allow
* ASMPC to refer to the start of the opcode instead of the patch pointer.
* This solves long standing BUG_0011 and BUG_0048.
*
* - ASMPC no longer stored in the symbol table and evaluated as a separate
* token, to allow expressions including ASMPC to be relocated. This solves
* long standing and never detected BUG_0047.
*
* - Handling ASMPC during assembly simplified - no need to call inc_PC() on
* every assembled instruction, no need to store list of JRPC addresses as
* ASMPC is now stored in the expression.
*
* BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
* ASMPC is computed on zero-base address of the code section and expressions
* including ASMPC are not relocated at link time.
* "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
* The expression ASMPC+3 is not marked as relocateable, and the resulting
* code only works when linked at address 0.
*
* BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
* In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
* of instruction-address.
*
* BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
* Bug only happens with forward references to relative addresses in expressions.
* See example from zx48.asm ROM image in t/BUG_0011.t test file.
* Need to change object file format to correct - need patchptr and address of instruction start.
*
* Revision 1.19  2014/04/15 21:07:18  pauloscustodio
* append_opcode() to append_byte() and inc_PC() in one go
*
* Revision 1.18  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.17  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.16  2014/02/19 23:59:26  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.15  2014/02/11 15:10:10  pauloscustodio
* ws
*
* Revision 1.14  2014/01/11 01:29:39  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.13  2014/01/09 23:26:24  pauloscustodio
* Use init.h mechanism, no need for main() calling init_codearea
*
* Revision 1.12  2014/01/02 19:44:39  pauloscustodio
* warning: "/","*" within comment [-Wcomment]
*
* Revision 1.11  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.10  2013/09/09 00:15:11  pauloscustodio
* Integrate codearea in init() mechanism.
*
* Revision 1.9  2013/05/16 22:39:39  pauloscustodio
* Bad include-once define
*
* Revision 1.8  2013/02/22 17:19:19  pauloscustodio
* Add listfile interface to append bytes to the listing
* Remove oldPC - no longer needed with new listfile
* Solve memory leak
*
* Revision 1.7  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (Byte)
* Replaced (unisigned int) by (UInt)
* Replaced (short) by (int)
*
* Revision 1.6  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.5  2012/11/03 17:39:35  pauloscustodio
* astyle, comments
*
* Revision 1.4  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.3  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
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
* Revision 1.2  2011/10/07 17:53:04  pauloscustodio
* BUG_0015 : Relocation issue - dubious addresses come out of linking
* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
* The effect was that all address calculations at link phase were considering
*  a start offset of zero for all modules.
* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
* - Consequence of these two issues were all linked addresses wrong.
*
* Revision 1.1  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); 
*   if only one byte is available in codearea, and a 2 byte instruction is assembled, 
*   the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
*
*/
