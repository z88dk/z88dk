/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fgetc.c,v 1.1 2002-05-10 11:08:56 dom Exp $
 */

#define ANSI_STDIO
#define STDIO_ASM

#include <stdio.h>
#include <fcntl.h>

/*
 *	struct fp {
 *		union xx {
 *			int fd;
 *			char *str;
 *		} desc;
 *		u8_t error;
 *		u8_t flags;
 *		u8_t ungetc;
 */

int fgetc(FILE *fp)
{
#ifdef Z80
#asm
	pop	bc
	pop	de	;fp
	push	de
	push	bc
	ld	hl,-1	;EOF
	inc	de	
	inc	de
	ld	a,(de)	;de = &fp_flags get flags
	and	a
	ret	z
	and	_IOWRITE | _IOEOF	;check we`re not write/EOF
	ret	nz
	inc	de	;de=&fp_ungetc
	ld	a,(de)	;check for ungot char
	and	a
	jr	z,no_ungetc
	ex	de,hl
	ld	e,a
	ld	d,0
	ld	(hl),d	;set no ungetc character
	ex	de,hl
	ret
.no_ungetc
; Now do strings
	dec	de	;de=&fp_flags
	ld	a,(de)
	and	_IOSTRING
	jr	z,no_string	;not a string
	ex	de,hl
	dec	hl		;fp_desc+1
	ld	d,(hl)
	dec	hl		;fp_desc
	ld	e,(hl)
	ld	a,(de)
	inc	de
	ld	(hl),e		
	inc	hl		;fp_desc+1
	ld	(hl),d
	ex	de,hl
	ld	hl,-1	;EOF
	and	a	;test for zero
	ret	z	;return EOF if so
	ld	l,a	;else return character
	ld	h,0
	ret
.no_string
#ifdef NET_STDIO
	ld	a,(de)	;*fp_flags
	and	_IONETWORK
	jr	z,no_net
	ex	de,hl
	ld	d,(hl)	;fp_desc+1
	dec	hl
	ld	e,(hl)	;fp_desc
	ex	de,hl
	push	de
	push	hl
	call	fgetc_net
	pop	bc
	pop	de
	ret	nc
	jr	seteof	;EOF reached (sock closed?)
.no_net
#endif
	dec	de	;fp_desc+1
	dec	de	;fp_desc
	push	de	;preserve fp
	call	fchkstd	;check for stdin (stdout/err have failed already)
	pop	de	;ix back
	jr	c,no_stdin
	call	fgetc_cons	;get from console
	ret			;always succeeds - never EOF
.no_stdin
	ex	de,hl
	ld	e,(hl)
	inc	hl		;fp_desc+1
	ld	d,(hl)
	dec	hl		;fp_desc
	ex	de,hl
	push	de
;	push	hl		;dont think this push/pop is needed
	call	readbyte	;readbyte sorts out stack (fastcall)
;	pop	bc		;dump handle
	pop	de		;get fp back
	ret	nc		;no error so return (make sure other
				;implementations respect this!)
.seteof
	inc	de	
	inc	de		;fp_flags
	ld	a,(de)
	or	_IOEOF
	ld	(de),a	;set EOF, return with EOF
#endasm
#else
        int     c;
        if ( fp->flags == 0 || (fp->flags & _IOWRITE)   ) return EOF;

        if (c=fp->ungetc) { fp->ungetc=0; return(c); }

        if ( fp->flags & _IOSTRING ) { c=*fp->desc.ptr++; return ( c ? c : EOF);}
        if ( (c=readbyte(fp->fd)) == EOF)
                        fp->flags&=_IOEOF;
        return(c);
#endif
}
