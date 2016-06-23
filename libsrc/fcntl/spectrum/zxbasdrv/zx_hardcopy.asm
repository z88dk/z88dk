;
; Just enter BASIC at the "Hardcopy" line
;
; Stefano - 12/7/2006
;
; void zx_hardcopy()
;
; $Id: zx_hardcopy.asm,v 1.5 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	zx_hardcopy
	PUBLIC	_zx_hardcopy
	
	EXTERN	zx_goto


.zx_hardcopy
._zx_hardcopy
	ld	hl,7800		; BASIC routine for "hardcopy"
	jp	zx_goto

