;
; Write a byte by the BASIC driver
;
; Stefano - 5/7/2006
;
; int writebyte(int handle, int byte)
;
; $Id: writebyte.asm,v 1.5 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	writebyte
	PUBLIC	_writebyte
	
.writebyte
._writebyte
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
