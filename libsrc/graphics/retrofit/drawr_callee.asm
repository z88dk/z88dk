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
;	$Id: drawr_callee.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  drawr(int x2, int y2)


SECTION smc_clib

PUBLIC     drawr_callee
PUBLIC    _drawr_callee

	EXTERN    drawr

.drawr_callee
._drawr_callee
	pop af	; ret addr
	pop	bc
	pop	de
	push af	; ret addr
	push de
	push bc
	
	call drawr
	pop bc
	pop bc
	ret
