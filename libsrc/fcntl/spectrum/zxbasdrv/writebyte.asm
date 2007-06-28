;
; Write a byte by the BASIC driver
;
; Stefano - 5/7/2006
;
; int writebyte(int handle, int byte)
;
; $Id: writebyte.asm,v 1.3 2007-06-28 20:16:20 stefano Exp $

	XLIB	writebyte
	
.writebyte
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc

	ld	bc,($5c3d)
	push	bc		; save original ERR_SP
	ld	bc,error
	push	bc
	ld	($5c3d),sp	; update error handling routine

	push	de
	ld	a,l	; stream # (handle)
	call	$1601
	pop	de
	ld	a,e
	
	push	af
	rst	16
	pop	af
	ld	h,0
	ld	l,a

	pop	bc
	pop	bc
	ld	($5c3d),bc	; restore orginal ERR_SP
	ret

.error
	pop	bc
	ld	($5c3d),bc	; restore orginal ERR_SP
	ld	(iy+0),255	; reset ERR_NR
	ld	(iy+124),0	; clear FLAGS3
	ld	hl,-1	; EOF
	ret
