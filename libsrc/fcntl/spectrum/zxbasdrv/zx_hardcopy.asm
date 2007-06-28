;
; Just enter BASIC at the "Hardcopy" line
;
; Stefano - 12/7/2006
;
; void zx_hardcopy()
;
; $Id: zx_hardcopy.asm,v 1.3 2007-06-28 20:16:20 stefano Exp $

	XLIB	zx_hardcopy
	
	LIB	zx_goto


.zx_hardcopy
	ld	hl,7800		; BASIC routine for "hardcopy"
	jp	zx_goto

