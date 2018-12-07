;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ xordraw(int x, int y, int x2, int y2)
;
;
;	$Id: xordraw_callee.asm $
;

SECTION code_graphics
PUBLIC xordraw_callee
PUBLIC _xordraw_callee

	EXTERN     xordraw

.xordraw_callee
._xordraw_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	hl,xordraw
	jp (hl)
	
.retaddr
		pop hl
		pop bc
		pop bc
		pop bc
		pop bc
		jp (hl)

