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
;	$Id: drawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  drawto(int x2, int y2)


SECTION smc_clib

PUBLIC     drawto_callee
PUBLIC    _drawto_callee

	EXTERN    drawto

.drawto_callee
._drawto_callee
	pop af	; ret addr
	pop	bc
	pop	de
	push af	; ret addr
	push de
	push bc
	
	call drawto
	pop bc
	pop bc
	ret
