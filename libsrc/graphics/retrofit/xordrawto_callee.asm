;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: xordrawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordrawto(int x2, int y2)


SECTION code_graphics

PUBLIC     xordrawto_callee
PUBLIC    _xordrawto_callee

	EXTERN    xordrawto

.xordrawto_callee
._xordrawto_callee
	pop af	; ret addr
	pop	bc
	pop	de
	push af	; ret addr
	push de
	push bc
	
	call xordrawto
	pop bc
	pop bc
	ret
