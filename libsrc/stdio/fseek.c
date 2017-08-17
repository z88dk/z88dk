/*
 *	Get the position of a file
 *
 *	long ftell(FILE *fp)
 *
 *	Calls some machine dependent routine to do the dirty work
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fseek.c,v 1.3 2016-03-06 12:12:57 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>

static long fseek1(FILE *fp, fpos_t posn, int whence) __z88dk_callee;

int fseek(FILE *fp, fpos_t posn, int whence)
{
	if ( fp->flags&_IOUSE && fchkstd(fp)== 0 ) {
		if (fseek1(fp,posn,whence) != -1L ) {
                        fp->flags &= ~_IOEOF;
			return 0;
		}
	}
	return 1;
}

#asm
fseek1:
	pop	af		;return address
	pop	bc		;whence
	pop	de		;posn
	pop	hl
	pop	ix		;fp
	push	af		;return address

	ld	a,(ix+fp_flags)
	and	_IOEXTRA
	jr	z, call_trampoline
; Normal file descriptor, just call lseek
	ld	a,c		;save whence
	ld	c,(ix+fp_desc)
	ld	b,(ix+fp_desc+1)
	push	bc		;descriptor
	push	hl		;posn
	push	de
	ld	c,a
	ld	b,0
	push	bc		;whence
	call	lseek
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret

call_trampoline:
; Call via the trampoline
	ld	a,c		;a = whence
	ld	c,l		;lower 16 bit of posn
	ld	b,h
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
	ex	af,af
	ld	a,__STDIO_MSG_SEEK
	call	l_jphl
	ret
#endasm






	


