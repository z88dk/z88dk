;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: remove.asm,v 1.2 2007-06-27 16:51:59 stefano Exp $

	XLIB	remove
	
	LIB	zx_goto
	LIB	zxgetfname

.remove
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	call	zxgetfname
	
	ld	hl,7900		; BASIC routine for "erase"
	call	zx_goto

	ret

