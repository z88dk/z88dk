;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ xorborder(int x, int y, int x2, int y2)
;
; XORs a dotted box.  Useful for GUIs.
;
;
;	$Id: xorborder_callee.asm $
;

SECTION smc_clib

PUBLIC xorborder_callee
PUBLIC _xorborder_callee

	EXTERN     xorborder

.xorborder_callee
._xorborder_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,xorborder
	jp (hl)
	
.retaddr
		pop bc
		pop bc
		pop bc
		pop bc
.retaddr0
		ld	hl,0
		jp (hl)

