
;
; Invoke a GSX/GIOS function with 1 coordinate (2 values) in "ptsin"
;

;
; $Id: gios_1px_callee.asm $
;

SECTION code_clib

PUBLIC	gios_1px_callee
PUBLIC	_gios_1px_callee

EXTERN	gios
EXTERN	gios_ctl
EXTERN	gios_ptsin

PUBLIC asm_gios_1px


gios_1px_callee:
_gios_1px_callee:


	pop	af
	pop	hl
	pop	bc
	pop de
	push af
	
.asm_gios_1px

	ld	(gios_ptsin+2),hl
	ld	h,b
	ld	l,c
	ld	(gios_ptsin),hl
	
	ld	hl,gios_ctl+2	; n_ptsin
	ld	(hl),1			; 1 XY coordinate
	inc hl
	ld	(hl),0
	ld	h,d			; fn
	ld	l,e
	jp	gios




