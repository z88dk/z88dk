/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fclose.c,v 1.5 2016-03-13 22:22:39 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>
#include <fcntl.h>



int __FASTCALL__ fclose(FILE *fp)
{
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
	ld	a,(hl)
	and	_IOEXTRA
	jr	z,fclose_no_net
; We have to go via trampoline here
	push	hl	;save flags pointer
	dec	hl
	dec	hl	;hl = fp
	push	ix	;Save callers ix
	push	hl
	pop	ix	;ix = fp
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
	ld	a,__STDIO_MSG_CLOSE
	call	l_jphl
	pop	ix	;restore callers ix
	jr	fclose_check_success
fclose_no_net:
	ld	a,(hl)
	and	_IOSYSTEM
	jr	nz, fclose_success

	push	hl	; points to flags
	push	de
	call	close
	pop	bc	;fd
fclose_check_success:
	pop	de	;flags pointer
	ld	a,h	; an error
	or	l
	ret	nz
	ex	de,hl
fclose_success:
	ld	de,0
	ld	(hl),e	;flags
	dec	hl
	ld	(hl),e	;descriptor + 1
	dec	hl
	ld	(hl),e
	ex	de,hl
#endasm
}
