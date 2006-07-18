;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: remove.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

	XLIB	remove
	
	LIB	zx_goto
	LIB	zxgetfname

.remove
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	call	zxgetfname
	
	ld	bc,7900		; BASIC routine for "erase"
	push	bc
	call	zx_goto
	pop	bc

	ret

