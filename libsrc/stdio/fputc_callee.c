/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fputc_callee.c,v 1.5 2016-03-06 21:36:52 dom Exp $
 */


#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>



int fputc_callee(int c,FILE *fp)
{
//#ifdef Z80
#asm

	pop	de
	pop	hl	;fp
	pop	bc	;c
	push 	de

        push	ix

	push	hl
	pop	ix
	call	asmentry

	pop	ix	
	ret

.asmentry

DEFC ASMDISP_FPUTC_CALLEE = # asmentry - fputc_callee
PUBLIC ASMDISP_FPUTC_CALLEE

;	pop	de
;	pop	ix	;fp
;	pop	bc	;c
;	push	bc
;	push	ix
;	push	de

	ld	hl,-1	;EOF
	ld	a,(ix+fp_flags)
	and	a	;no thing
	ret	z
	and	_IOREAD
	ret	nz	;don`t want reading streams
	ld	a,(ix+fp_flags)
	and	_IOSTRING
	jr	z,no_string
	ld	e,(ix+fp_extra)
	ld	d,(ix+fp_extra+1)
	ld	a,d
	or	e
	jr	nz,print_char_to_buf
	ex	de,hl		;hl = 0
	dec	hl		;hl = -1, EOF
	ret
.print_char_to_buf
	dec	de
	ld	(ix+fp_extra),e
	ld	(ix+fp_extra+1),d
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
	pop	hl
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
#ifdef __STDIO_BINARY
#ifdef __STDIO_CRLF
	ld	a,_IOTEXT	;check for text mode
	and	(ix+fp_flags)
	jr	z,no_binary
	ld	a,c		;load bytes
	cp	13
	jr	nz,no_binary
	push	bc	;c
	call	writebyte
	pop	bc
	ld	c,10
.no_binary
#endif
#endif
	push	bc	;c
	call	writebyte
	pop	hl	;discard values
	pop	bc	; fd
	ret
#endasm

/*
 *  This code portion probably can't be used anymore as we're in 'CALLEE' mode.
 * 
#else
        if ( fp->flags == 0 || fp->flags & _IOREAD ) return EOF;

        if ( fp->flags & _IOSTRING ) {
                *fp->desc.ptr++=(char) c;
                return(c);
	} 
#ifdef NET_STDIO
	if ( fp->flags & _IONETWORK)
		return(fputc_net(fp->fd,c));
#endif
	return (writebyte(fp->fd,c));
#endif
*/

}
