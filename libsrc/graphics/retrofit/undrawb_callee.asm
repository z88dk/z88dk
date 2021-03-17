;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ undrawb(int x, int y, int x2, int y2)
;
;
;	$Id: undrawb_callee.asm $
;

SECTION smc_clib

PUBLIC undrawb_callee
PUBLIC _undrawb_callee

	EXTERN     undrawb

.undrawb_callee
._undrawb_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,undrawb
	jp (hl)
	
.retaddr
		pop bc
		pop bc
		pop bc
		pop bc
.retaddr0
		ld	hl,0
		jp (hl)

