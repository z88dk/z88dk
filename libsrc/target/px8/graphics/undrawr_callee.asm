;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
; ----- void __CALLEE__ undrawr(int x2, int y2)
;
;	$Id: undrawr_callee.asm $
;

	SECTION   code_graphics

	PUBLIC    undrawr_callee
	PUBLIC    _undrawr_callee
	
	PUBLIC    asm_undrawr

	EXTERN    do_drawr


.undrawr_callee
._undrawr_callee	
	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	push	af	; ret addr
	
.asm_undrawr
	ld		a,1
	jp      do_drawr


