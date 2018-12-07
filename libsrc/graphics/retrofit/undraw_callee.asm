;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ undraw(int x, int y, int x2, int y2)
;
;
;	$Id: undraw_callee.asm $
;

SECTION code_graphics
PUBLIC undraw_callee
PUBLIC _undraw_callee

	EXTERN     undraw

.undraw_callee
._undraw_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,undraw
	jp (hl)
	
.retaddr
		pop hl
		pop bc
		pop bc
		pop bc
		pop bc
		jp (hl)

