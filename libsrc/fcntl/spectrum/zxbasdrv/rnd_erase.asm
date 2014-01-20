;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: rnd_erase.asm,v 1.1 2014-01-20 09:15:31 stefano Exp $

	XLIB	rnd_erase
	
	LIB	zx_goto
	LIB	zxgetfname2

.rnd_erase
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	call	zxgetfname2
	
	ld	hl,7900		; BASIC routine for "erase"
	jp	zx_goto

