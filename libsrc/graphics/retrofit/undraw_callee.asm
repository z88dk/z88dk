;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ undraw(int x, int y, int x2, int y2)
;
;
;	$Id: undraw_callee.asm $
;

SECTION smc_clib

PUBLIC undraw_callee
PUBLIC _undraw_callee

	EXTERN     undraw

.undraw_callee
._undraw_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,undraw
	jp (hl)
	
.retaddr
		pop bc
		pop bc
		pop bc
		pop bc
.retaddr0
		ld	hl,0
		jp (hl)

