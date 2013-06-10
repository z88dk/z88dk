/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fgetc.c,v 1.10 2013-06-10 13:15:50 stefano Exp $
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
//#ifdef Z80
#asm
;__FASTCALL__
;	pop	bc
;	pop	ix	;fp
;	push	ix
;	push	bc

	push hl
	pop ix

	ld	hl,-1	;EOF
	ld	a,(ix+fp_flags)	;get flags
	and	a
	ret	z
	and	_IOWRITE | _IOEOF	;check we`re not write/EOF
	ret	nz
	ld	a,(ix+fp_ungetc)	;check for ungot char
	and	a
	jr	z,no_ungetc
	ld	l,a
	ld	h,0
	ld	(ix+fp_ungetc),h
	ret
.no_ungetc
; Now do strings
	ld	a,(ix+fp_flags)
	and	_IOSTRING
	jr	z,no_string	;not a string
	ld	e,(ix+fp_desc)
	ld	d,(ix+fp_desc+1)
	ld	a,(de)
	inc	de
	ld	(ix+fp_desc),e
	ld	(ix+fp_desc+1),d
	ld	hl,-1	;EOF
	and	a	;test for zero
	ret	z	;return EOF if so
	ld	l,a	;else return character
	ld	h,0
	ret
.no_string
#ifdef NET_STDIO
	ld	a,(ix+fp_flags)
	and	_IONETWORK
	jr	z,no_net
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	ix
	push	hl
	call	fgetc_net
	pop	bc
	pop	ix
	ret	nc
	jr	seteof	;EOF reached (sock closed?)
.no_net
#endif
	push	ix	;preserve fp
	call	fchkstd	;check for stdin (stdout/err have failed already)
	pop	ix	;ix back
	jr	c,no_stdin
	call	fgetc_cons	;get from console
#ifdef __STDIO_EOFMARKER
	cp	__STDIO_EOFMARKER
	jr	z,is_eof
#endif
	push    hl
	call    fputc_cons
	pop     hl
	ret			; always succeeds - never EOF when EOF has not been defined.
.no_stdin
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	ix
;	push	hl		;dont think this push/pop is needed
	call	readbyte	;readbyte sorts out stack (fastcall)
;	pop	bc		;dump handle
	pop	ix		;get fp back
#ifdef __STDIO_BINARY
#ifdef __STDIO_CRLF
	ld	a,_IOTEXT	;check for text mode
	and	(ix+fp_flags)
	jr	z,no_binary
	ld	a,l
#ifdef __STDIO_EOFMARKER
	cp	__STDIO_EOFMARKER
	jr	z,is_eof
	and a
	jr	z,is_eof
#endif
	cp	13
	jr	z,no_stdin
	cp	10
	jr	nz,no_binary
	ld	l,13
.no_binary
#endif
#endif
	; enforcement to the EOF checks, Stefano 21/6/2012
	ld	a,h
	inc a
	jr  z,is_eof

#ifdef __STDIO_BINARY
	ld	a,_IOTEXT	;check for text mode
	and	(ix+fp_flags)
	ret	z
	ld	a,l		;load bytes
	sub	__STDIO_EOFMARKER	;compare with the EOF marker
	and	a		;reset carry
	ret	nz
#else
	ret	nc		;no error so return (make sure other
				;implementations respect this!)
#endif
.is_eof
	ld	hl,-1		;signify EOF
.seteof
	ld	a,(ix+fp_flags)
	or	_IOEOF
	ld	(ix+fp_flags),a	;set EOF, return with EOF
#endasm
/*
#else
        int     c;
        if ( fp->flags == 0 || (fp->flags & _IOWRITE)   ) return EOF;

        if (c=fp->ungetc) { fp->ungetc=0; return(c); }

        if ( fp->flags & _IOSTRING ) { c=*fp->desc.ptr++; return ( c ? c : EOF);}
        if ( (c=readbyte(fp->fd)) == EOF)
                        fp->flags&=_IOEOF;
        return(c);
#endif
*/
}
