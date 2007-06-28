;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: remove.asm,v 1.3 2007-06-28 20:16:20 stefano Exp $

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
	jp	zx_goto

