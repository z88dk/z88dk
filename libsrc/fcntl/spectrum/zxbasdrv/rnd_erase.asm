;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: rnd_erase.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $

	PUBLIC	rnd_erase
	
	EXTERN	zx_goto
	EXTERN	zxgetfname2

.rnd_erase
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	call	zxgetfname2
	
	ld	hl,7900		; BASIC routine for "erase"
	jp	zx_goto

