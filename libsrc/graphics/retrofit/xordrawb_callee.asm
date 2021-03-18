;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ xordrawb(int x, int y, int x2, int y2)
;
;
;	$Id: xordrawb_callee.asm $
;

SECTION smc_clib

PUBLIC xordrawb_callee
PUBLIC _xordrawb_callee

	EXTERN     xordrawb

.xordrawb_callee
._xordrawb_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,xordrawb
	jp (hl)
	
.retaddr
		pop bc
		pop bc
		pop bc
		pop bc
.retaddr0
		ld	hl,0
		jp (hl)

