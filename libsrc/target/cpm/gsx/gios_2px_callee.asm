
;
; Invoke a GSX/GIOS function with 2 coordinates (4 values) in "ptsin"
;

;
; $Id: gios_2px_callee.asm $
;

SECTION code_clib

PUBLIC	gios_2px_callee
PUBLIC	_gios_2px_callee

EXTERN	gios
EXTERN	gios_ctl
EXTERN	gios_ptsin

PUBLIC asm_gios_2px


gios_2px_callee:
_gios_2px_callee:

	pop bc
	ld	hl,gios_ptsin+7
	pop	de
	ld	(hl),d
	dec hl
	ld	(hl),e
	dec hl
	pop	de
	ld	(hl),d
	dec hl
	ld	(hl),e
	dec hl
	pop	de
	ld	(hl),d
	dec hl
	ld	(hl),e
	dec hl
	pop	de
	ld	(hl),d
	dec hl
	ld	(hl),e
	pop	de		; fn
	push bc
	
.asm_gios_2px

	ld	hl,gios_ctl+2	; n_ptsin
	ld	(hl),2			; 2 xy coordinates = (4 int parameters)
	inc hl
	ld	(hl),0
	ld	h,d			; fn
	ld	l,e
	jp	gios




