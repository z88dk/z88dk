;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: remove.asm,v 1.4 2015-01-21 08:09:27 stefano Exp $

	PUBLIC	remove
	
	EXTERN	zx_goto
	EXTERN	zxgetfname

.remove
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	call	zxgetfname
	
	ld	hl,7900		; BASIC routine for "erase"
	jp	zx_goto

