;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: drawto_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  drawto(int x2, int y2)


SECTION code_graphics

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
