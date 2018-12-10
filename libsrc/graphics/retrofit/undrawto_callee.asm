;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;

;
;	$Id: undrawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undrawto(int x2, int y2)


SECTION smc_clib

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
