/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fclose.c,v 1.4 2016-03-06 21:55:07 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ fclose(FILE *fp)
{
#ifdef Z80
#asm
	pop	de
	pop	hl
	push	hl
	push	de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)
	and	_IOUSE		;inuse?
	jr	nz, fclose_inuse
fclose_error:
	ld	hl,-1		;EOF
	ret
fclose_inuse:
	ld	a,(hl)
	and	_IOSTRING
	jr	nz,fclose_success
#ifdef NET_STDIO
	ld	a,(hl)
	and	_IONETWORK
	jr	z,fclose_no_net

	push	de
	push	hl
	call	closenet
	jr	fclose_check_success
fclose_no_net:
#endif
	ld	a,(hl)
	and	_IOSYSTEM
	jr	nz, fclose_success

	push	hl	; points to flags
	push	de
	call	close
fclose_check_success:
	pop	bc	;fd
	pop	de	;flags pointer
	ld	a,h	; an error
	or	l
	ret	nz
	ex	de,hl
fclose_success:
	ld	(hl),0	;flags
	dec	hl
	ld	(hl),0	;descriptor + 1
	dec	hl
	ld	(hl),0
	ld	hl,0
#endasm
#else
        if ( (fp->flags&_IOUSE ==0 )  ||  (fp->flags&_IOSTRING) )  return(EOF);

	if (fchkstd(fp) == 0 ) {
		if (close(fp->desc.fd) ) return EOF;
	}
	fp->desc.fd=0;
	fp->flags=0;
	return 0;
#endif
}
