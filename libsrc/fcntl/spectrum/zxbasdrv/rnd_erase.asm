;
; Delete a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int remove(char *name)
;
; $Id: rnd_erase.asm,v 1.3 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	rnd_erase
	PUBLIC	_rnd_erase
	
	EXTERN	zx_goto
	EXTERN	zxgetfname2

.rnd_erase
._rnd_erase
	pop	bc
	pop	hl
	push	hl
	push	bc
	
	call	zxgetfname2
	
	ld	hl,7900		; BASIC routine for "erase"
	jp	zx_goto

