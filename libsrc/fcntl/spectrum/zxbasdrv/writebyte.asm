;
; Write a byte by the BASIC driver
;
; Stefano - 5/7/2006
;
; int writebyte(int handle, int byte)
;
; $Id: writebyte.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

	XLIB	writebyte
	
.writebyte
	pop	bc
	pop	de
	pop	hl
	push	hl
	push	de
	push	bc

	push	de
	ld	a,l	; stream # (handle)
	call	$1601
	pop	de
	ld	a,e
	
	rst	16

	ret
