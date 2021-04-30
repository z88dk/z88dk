
;
; Invoke a GSX/GIOS function with a single parameter in "intin"
;

;
; $Id: gios_1pm_callee.asm $
;

SECTION code_clib

PUBLIC	gios_1pm_callee
PUBLIC	_gios_1pm_callee

EXTERN	gios
EXTERN	gios_ctl
EXTERN	gios_intin

PUBLIC asm_gios_1pm


gios_1pm_callee:
_gios_1pm_callee:

	pop af
	pop	de	; parameter
	pop	bc	; fn number
	push	af


.asm_gios_1pm

	ld	hl,gios_intin
	ld	(hl),e
	inc hl
	ld	(hl),d
	ld	a,1
	ld	hl,gios_ctl+6	; parameter count (n_intin)
	ld	(hl),a
	inc hl
	ld	(hl),0
	ld	h,b
	ld	l,c
	jp	gios




