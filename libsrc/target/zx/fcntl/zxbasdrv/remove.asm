;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: remove.asm,v 1.5 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	remove
	PUBLIC	_remove
	
	EXTERN	zx_goto
	EXTERN	zxgetfname

.remove
._remove
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	call	zxgetfname
	
	ld	hl,7900		; BASIC routine for "erase"
	jp	zx_goto

