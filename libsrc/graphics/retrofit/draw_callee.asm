;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)
;
;
;	$Id: draw_callee.asm $
;

SECTION code_graphics
PUBLIC draw_callee
PUBLIC _draw_callee

	EXTERN     draw

.draw_callee
._draw_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,draw
	jp (hl)
	
.retaddr
		pop hl
		pop bc
		pop bc
		pop bc
		pop bc
		jp (hl)

