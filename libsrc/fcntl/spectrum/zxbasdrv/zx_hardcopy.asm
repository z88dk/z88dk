;
; Just enter BASIC at the "Hardcopy" line
;
; Stefano - 12/7/2006
;
; void zx_hardcopy()
;
; $Id: zx_hardcopy.asm,v 1.2 2007-06-27 16:51:59 stefano Exp $

	XLIB	zx_hardcopy
	
	LIB	zx_goto


.zx_hardcopy
	ld	hl,7800		; BASIC routine for "hardcopy"
	call	zx_goto
	ret

