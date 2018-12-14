;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: xorplot_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xorplot(int x, int y)


SECTION code_graphics

PUBLIC     xorplot_callee
PUBLIC    _xorplot_callee

	EXTERN    xorplot

.xorplot_callee
._xorplot_callee
	pop af	; ret addr
	pop	bc
	pop	de
	push af	; ret addr
	push de
	push bc
	
	call xorplot
	pop bc
	pop bc
	ret
