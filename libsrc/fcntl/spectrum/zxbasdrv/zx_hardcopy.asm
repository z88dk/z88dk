;
; Just enter BASIC at the "Hardcopy" line
;
; Stefano - 12/7/2006
;
; void zx_hardcopy()
;
; $Id: zx_hardcopy.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

	XLIB	zx_hardcopy
	
	LIB	zx_goto


.zx_hardcopy
	ld	bc,7800		; BASIC routine for "hardcopy"
	push	bc
	call	zx_goto
	pop	bc
	ret

