/*
 *      Part of the library for fcntlt
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
 *      All others are ignored(!)
 *
 * -----
 * $Id: open.c,v 1.3 2016-06-13 19:55:48 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

static int nropen(char *name, int flags, mode_t mode, char *buf, size_t len)
{
#asm
        INCLUDE "fileio.def"
       
        push	ix		;save callers ix 
        ld      ix,2
        add     ix,sp
        ld      l,(ix+10)        ;lower 16 of filename
        ld      h,(ix+11)
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
	push	ix		;get fd into de
	pop	de
	pop	ix		;restore ix
        ld      hl,-1
        ret     c               ;open error
	ex	de,hl		;hl = filedescriptor
#endasm
}


int open(char *name, int flags, mode_t mode)
{
	char	buffer[10];	/* Buffer for expansion */

	return (nropen(name,flags,mode,buffer,9));
}

