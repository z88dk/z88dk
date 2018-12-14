;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: point_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- int  point(int x, int y)


SECTION code_graphics

PUBLIC     point_callee
PUBLIC    _point_callee

	EXTERN    point

.point_callee
._point_callee
	pop af	; ret addr
	pop	bc
	pop	de
	push af	; ret addr
	push de
	push bc
	
	call point
	pop bc
	pop bc
	ret
