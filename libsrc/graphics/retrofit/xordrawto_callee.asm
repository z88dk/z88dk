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
;	$Id: xordrawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xordrawto(int x2, int y2)


SECTION smc_clib

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
