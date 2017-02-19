/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fgetc.c,v 1.13 2016-03-06 21:36:52 dom Exp $
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
	pop	bc
	pop	hl	;fp
	push	hl
	push	bc
        push    ix      ; callers ix
        push    hl
        pop     ix

	ld	hl,-1	;EOF
	ld	a,(ix+fp_flags)	;get flags
	and	a
	jp	z, fgetc_end
	and	_IOWRITE | _IOEOF	;check we`re not write/EOF
	jp      nz, fgetc_end
	ld	a,(ix+fp_ungetc)	;check for ungot char
	and	a
	jr	z,no_ungetc
	ld	l,a
	ld	h,0
	ld	(ix+fp_ungetc),h
        jp      fgetc_end
.no_ungetc
; Now do strings
	ld	a,(ix+fp_flags)
	and	_IOSTRING
	jr	z,no_string	;not a string
	ld	e,(ix+fp_extra)	; check the length
	ld	d,(ix+fp_extra+1)
	ld	a,d
	or	e
	jr	z,is_eof
	dec	de
	ld	(ix+fp_extra),e
	ld	(ix+fp_extra+1),d
	ld	e,(ix+fp_desc)
	ld	d,(ix+fp_desc+1)
	ld	a,(de)
	inc	de
	ld	(ix+fp_desc),e
	ld	(ix+fp_desc+1),d
	ld	hl,-1	;EOF
	and	a	;test for zero
	jr      z,fgetc_end	;return EOF if so
	ld	l,a	;else return character
	ld	h,0
        jr      fgetc_end
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
	jr      nc, fgetc_end
	jr	seteof	;EOF reached (sock closed?)
.no_net
#endif
	push	ix	;preserve fp
	call	fchkstd	;check for stdin (stdout/err have failed already)
	pop	ix	;ix back
	jr	c,no_stdin
	call	fgetc_cons	;get from console
#ifdef __STDIO_EOFMARKER
	ld	a,l
	cp	__STDIO_EOFMARKER
	jr	z,is_eof
#endif
	push    hl
	call    fputc_cons
	pop     hl
        jr      fgetc_end ; always succeeds - never EOF when EOF has not been defined.
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
	jr      z,fgetc_end
	ld	a,l		;load bytes
	sub	__STDIO_EOFMARKER	;compare with the EOF marker
	and	a		;reset carry
        jr      nz,fgetc_end
#else
	jr      nc,fgetc_end		;no error so return (make sure other
				;implementations respect this!)
#endif
.is_eof
	ld	hl,-1		;signify EOF
.seteof
	ld	a,(ix+fp_flags)
	or	_IOEOF
	ld	(ix+fp_flags),a	;set EOF, return with EOF
.fgetc_end
        pop     ix
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
