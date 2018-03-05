/*
 *	  New stdio functions for Small C+
 *
 *	  djm 4/5/99
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
#asm
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(sp + 2)
	push	ix		;save callers ix
	ld	ix,hl
ELSE
	pop	bc
	pop	hl	; fp
	push	hl
	push	bc
	push	ix	; callers ix
	push	hl
	pop	ix
ENDIF

	ld	a,(ix+fp_flags)	;get flags
	and	a
	jp	z, is_eof
	and	_IOWRITE | _IOEOF	;check we`re not write/EOF
	jp	nz, is_eof
	ld	a,(ix+fp_ungetc)	;check for ungot char
	and	a
	jr	z,no_ungetc
	ld	l,a
	ld	h,0
	ld	(ix+fp_ungetc),h
	jp	fgetc_end
.no_ungetc
; Now do strings
	ld	a,(ix+fp_flags)
	and	_IOSTRING
	jr	z,no_string	;not a string
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix+fp_extra)	; check the length
ELSE
	ld	l,(ix+fp_extra)	; check the length
	ld	h,(ix+fp_extra+1)
ENDIF
	ld	a,h
	or	l
	jp	z,is_eof
	dec	hl
IF __CPU_R2K__ | __CPU_R3K__
	ld	(ix+fp_extra),hl
ELSE
	ld	(ix+fp_extra),e
	ld	(ix+fp_extra+1),d
ENDIF

IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix+fp_desc)
ELSE
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
ENDIF
	ld	a,(hl)
	inc	hl
IF __CPU_R2K__ | __CPU_R3K__
	ld	(ix+fp_desc),hl
ELSE
	ld	(ix+fp_desc),l
	ld	(ix+fp_desc+1),h
ENDIF
	and	a		;test for zero
	jr	z,is_eof	;return EOF if so
	ld	l,a		;else return character
	ld	h,0
	jr	fgetc_end
.no_string
	ld	a,(ix+fp_flags)
	and	_IOEXTRA
	jr	z,not_extra_fp
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix + fp_extra)
ELSE
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
ENDIF
	ld	a,__STDIO_MSG_GETC
	call	l_jphl
	jr	nc, fgetc_end
	jr	seteof		;EOF reached (sock closed?)
.not_extra_fp
	push	ix		;preserve fp
	call	fchkstd		;check for stdin (stdout/err have failed already)
	pop	ix		;ix back
	jr	c,no_stdin
	call	fgetc_cons	;get from console
#ifdef __STDIO_EOFMARKER
	ld	a,l
	cp	__STDIO_EOFMARKER
	jr	z,is_eof
#endif
	push	hl
	call	fputc_cons
	pop	hl
	jr	fgetc_end	; always succeeds - never EOF when EOF has not been defined.
.no_stdin
IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(ix+fp_desc)
ELSE
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
ENDIF
	push	ix
	call	readbyte	; readbyte sorts out stack (fastcall)
				; hl = byte read
				; c = EOF
				; nc = good
	pop	ix		; get fp back
#ifdef __STDIO_BINARY
	ld	a,_IOTEXT	;check for text mode
	and	(ix+fp_flags)
	jr	z,not_text_fp
	ld	a,l
#ifdef __STDIO_EOFMARKER
	cp	__STDIO_EOFMARKER	;compare with the EOF marker
	jr	z,is_eof
#endif
#ifdef __STDIO_CRLF
	cp	13
	jr	z,no_stdin		; Read again
#endif
.not_text_fp
#endif
	; Check for value of -1
	ld	a,h
	inc	a
	jr	nz,fgetc_end
.is_eof
	ld	hl,-1		;signify EOF
.seteof
	ld	a,(ix+fp_flags)
	or	_IOEOF
	ld	(ix+fp_flags),a	;set EOF, return with EOF
.fgetc_end
	pop	 ix
#endasm
}
