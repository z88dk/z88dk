;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: undrawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undrawto(int x2, int y2)


SECTION code_graphics

PUBLIC     undrawto_callee
PUBLIC    _undrawto_callee

	EXTERN    undrawto

.undrawto_callee
._undrawto_callee
	pop af	; ret addr
	pop	bc
	pop	de
	push af	; ret addr
	push de
	push bc
	
	call undrawto
	pop bc
	pop bc
	ret
