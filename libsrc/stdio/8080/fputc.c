/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fputc.c,v 1.1 2002-05-10 11:08:56 dom Exp $
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
	pop	hl	
	pop	de	;fp
	pop	bc	;c
	push	bc
	push	de	
	push	hl

	ld	hl,-1	;EOF
	inc	de
	inc	de	;fp_flags
	ld	a,(de)
	and	a	;no thing
	ret	z
	and	_IOREAD
	ret	nz	;don`t want reading streams
	ld	a,(de)
	and	_IOSTRING
	jr	z,no_string
	ex	de,hl
	dec	hl	;fp_desc+1
	ld	d,(hl)
	dec	hl	;&fp_desc
	ld	e,(hl)
	ld	a,c	;store character
	ld	(de),a
	inc	de	;inc pointer and store
	ld	(hl),e
	inc	hl	;fp_desc+1
	ld	(hl),d
	ld	l,c	;load char to return
	ld	h,0
	ret
.no_string
#ifdef NET_STDIO
	ld	a,(de)	;fp_flags
	and	_IONETWORK
	jr	z,no_net
	ex	de,hl
	dec	hl
	ld	d,(hl)
	dec	hl	;fp_desc
	ld	e,(hl)
	push	de	;socket
	push	bc	;byte
	call	fputc_net
	pop	bc
	pop	bc
	ret
.no_net
#endif
	dec	de
	dec	de	;fp_desc
	push	de
	call	fchkstd	;preserves bc
	pop	de
	jr	c,no_cons
; Output to console
	push	bc
	call	fputc_cons
	pop	hl
	ret
.no_cons
; Output to file
	ex	de,hl
	ld	e,(hl)	;fp_desc
	inc	hl
	ld	d,(hl)
	push	de	;fd
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
