/*
 *      Part of the library for fcntlt
 *
 *      int creat(char *name,mode_t mode)
 *
 *      djm 27/4/99
 *
 * -----
 * $Id: creat.c,v 1.5 2016-06-13 19:55:48 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int creat(char *name, mode_t mode)
{
#asm
        INCLUDE "fileio.def"
        push	ix 		;save callers
        ld      ix,2
        add     ix,sp
        ld      e,(ix+4)        ;lower 16 of filename
        ld      d,(ix+5)
        ld      a,2             ;write starts from the start?!?!?
        ld      hl,-10
        add     hl,sp
        ld      sp,hl
        ex      de,hl           ;swap where to expand and filename over
        ld      c,10            ;maximum length of expanded filename
        call_oz(gn_opf)
        ex      af,af		;save result flags
        ld      hl,10
        add     hl,sp
        ld      sp,hl           ;restore our stack (we did nothing to it!)
        push    ix              ;get filedescriptor in ix into de
        pop     de		;
	pop	ix		;restore callers ix
        ld      hl,-1
        ex      af,af		;result flags
        ret     c               ;open error
	ex	de,hl
#endasm
}

