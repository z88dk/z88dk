/*
 *      Part of the library for fcntl
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 27/4/99
 *
 *      Access is either
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1    Starts afresh?!?!?
 *      O_APPEND = 256
 *
 *      All others are ignored(!) - i.e. mode is ignored
 *
 *	djm 24/3/2000 - Takes a buffer for expanded filename
 *
 * -----
 * $Id: open_z88.c,v 1.2 2001-04-18 14:59:40 stefano Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open_z88(far char *name, int flags, mode_t mode, char *buf, size_t len)
{
#asm
        INCLUDE "#fileio.def"
        
        ld      ix,0
        add     ix,sp
        ld      l,(ix+10)        ;lower 16 of filename
        ld      h,(ix+11)
        ld      e,(ix+12)        ;bank for filename
	ld	d,0
	push	de
	push	hl
	call	_cpfar2near	;in crt0 code so can be null fn
				;returns hl with buffer in near mem
				;fixes the stack as well
	ld	b,0
        ld      a,(ix+8)        ;access flags
        ld      c,(ix+9)        ;top 8 of flags
        bit     0,c             ;append!
        jr      z,l_open1
        ld      a,2             ;OZ append mode-1
.l_open1
        inc     a               ;convert from UNIX mode to OZ flags
	ld	e,(ix+4)	;buf
	ld	d,(ix+5)
        ld      c,(ix+2)        ;maximum length of expanded filename
        call_oz(gn_opf)
        ld      hl,-1
        ret     c               ;open error
        push    ix              ;get filedescriptor in ix into hl
        pop     hl
#endasm
}

