/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fputc.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */


#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>



int fputc(int c,FILE *fp)
{
#ifdef Z80
#asm
	pop	de
	pop	ix	;fp
	pop	bc	;c
	push	bc
	push	ix
	push	de
	ld	hl,-1	;EOF
	ld	a,(ix+fp_flags)
	and	a	;no thing
	ret	z
	and	_IOREAD
	ret	nz	;don`t want reading streams
	ld	a,(ix+fp_flags)
	and	_IOSTRING
	jr	z,no_string
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	ld	(hl),c
	inc	hl
	ld	(ix+fp_desc),l
	ld	(ix+fp_desc+1),h
	ld	l,c	;load char to return
	ld	h,0
	ret
.no_string
#ifdef NET_STDIO
	ld	a,(ix+fp_flags)
	and	_IONETWORK
	jr	z,no_net
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl	;socket
	push	bc	;byte
	call	fputc_net
	pop	bc
	pop	bc
	ret
.no_net
#endif
	push	ix
	call	fchkstd	;preserves bc
	pop	ix
	jr	c,no_cons
; Output to console
	push	bc
	call	fputc_cons
	pop	hl
	ret
.no_cons
; Output to file
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl	;fd
	push	bc	;c
	call	writebyte
	pop	bc	;discard values
	pop	bc
#endasm
#else
        if ( fp->flags == 0 || fp->flags & _IOREAD ) return EOF;

        if ( fp->flags & _IOSTRING ) {
                *fp->desc.ptr++=(char) c;
                return(c);
	} 
#ifdef NET_STDIO
	if ( fp->flags & _IONETWORK)
		return(fputc_net(fp->fd,c)
#endif
	return (writebyte(fp->fd,c));
#endif
}
