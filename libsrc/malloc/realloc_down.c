/*
 *      Small C+ Library
 *
 *      More Memory Functions
 *
 *      Added to Small C+ 12/3/99 djm
 *
 *      This one is writ by me!
 *
 *
 *      void *realloc_down(void *old, int new)
 *
 *      Reduce the size of a memory block (cannot increase it!)
 *
 *
 *      $Id: realloc_down.c,v 1.1 2002-05-22 20:12:37 dom Exp $
 */

#include <malloc.h>



void *realloc_down(void *addr, int smaller_size)
{
#asm
	pop	bc
	pop	de	;size
	pop	ix	;addr
	push	ix
	push	de
	push	bc
	push	ix	;save for the end

        inc     de
        push    hl
        pop     ix
        ld      c,e	;bc holds desired length
        ld      b,d
        ld      hl,4
        add     hl,de
        ex      de,hl   ;de=true length of blk (including malloc overhead)
; Pick up allocated size
        ld      l,(ix-2)
        ld      h,(ix-1)
; Decrease by 4 to cover overhead of malloc block
        dec     hl
        dec     hl
        dec     hl
        dec     hl
        and     a
        sbc     hl,de
	jr	c,__exit	;not big enough for a block
        ld      a,h
        or      l
	jr	z,__exit	;just the right size so no point in new block
; So room to make a new block above this one
        ld      (ix-2),e
        ld      (ix-1),d
        add     ix,bc   ;ix now points to start of new block
        ex      de,hl
        inc     de
        inc     de
        inc     de
        inc     de
        ld      (ix+2),e        ;store length of "free" packet
        ld      (ix+3),d
        push    ix
        pop     hl
        inc     hl
        inc     hl
        inc     hl
        inc     hl
        push    hl
        call    free
        pop     bc
.__exit
	pop	hl		;addr back again
#endasm
}
