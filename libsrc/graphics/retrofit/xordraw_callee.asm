;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ xordraw(int x, int y, int x2, int y2)
;
;
;	$Id: xordraw_callee.asm $
;

SECTION smc_clib

PUBLIC xordraw_callee
PUBLIC _xordraw_callee

	EXTERN     xordraw

.xordraw_callee
._xordraw_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,xordraw
	jp (hl)
	
.retaddr
		pop bc
		pop bc
		pop bc
		pop bc
.retaddr0
		ld	hl,0
		jp (hl)

