/*
 *	open() for +3DOS
 *
 *	djm 17/3/2000
 *
 *      Access is either
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1    Starts afresh?!?!?
 *      O_APPEND = 256
 *
 *	+3 notes:
 *	Open a file for reading - e=1 d=0
 *	Open a file for writing - e=4, d=2 (creat)
 *	Open a file for append  - e=2, d=2
 *
 *	$Id: open.c,v 1.8 2016-06-13 19:55:48 dom Exp $
 */

#include <fcntl.h>      /* Or is it unistd.h, who knows! */
#include <spectrum.h>

int open(char *name, int flags, mode_t mode)
{                                      
#asm
	INCLUDE	"p3dos.def"
	EXTERN	dodos
	push	ix
	ld	ix,4
	add	ix,sp
	ld	a,(ix+3)	;flags high
	and	a
	jr	nz,ck_append
	ld	a,(ix+2)
	and	a
	ld	de,$0001	;read mode
	jr	z,open_it
	ld	de,$0204	;write mode
	dec	a
	jr	z,open_it
.open_abort
	pop	ix
	ld	hl,-1		;invalid mode
	scf
	ret
.ck_append
	dec	a
	jr	nz,open_abort
	ld	a,(ix+2)
	and	a
	jr	nz,open_abort	;cant have low byte set
	ld	de,$0202	;append mode
.open_it
	push	de
	call	findhand
	pop	de
	jr	c,open_abort
	push	hl		;save handle number
	ld	b,l		;b=file number
	ld	c,3		;exclusive read/write - who cares?
; Offset the stack so we have somewhere to store our nobbled name
; - we need to replace the '\0' with a 255
	ld	hl,-20
	add	hl,sp		;hl now points to filename
	ld	sp,hl
	push	de		;save open mode
	push	bc		;save file etc
	push	hl		;save filename
	ld	e,(ix+4)	;filename
	ld	d,(ix+5)
	ld	b,15
.copyloop
	ld	a,(de)
	and	a
	jr	z,endcopy
	ld	(hl),a
	inc	hl
	inc	de
	djnz	copyloop
.endcopy
	ld	(hl),255
	pop	hl
	pop	bc
	pop	de
	ld	iy,DOS_OPEN
	call	dodos
	ex	af,af		;save flags
	ld	hl,20		;repair the stack after our storage
	add	hl,sp
	ld	sp,hl
	ex	af,af
	pop	hl		;file number back
	jr	nc,open_abort	;error
	pop	ix
#endasm
}

