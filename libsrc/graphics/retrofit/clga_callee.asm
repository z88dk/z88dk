;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ clga(int x, int y, int x2, int y2)
;
;
;	$Id: clga_callee.asm $
;

SECTION smc_clib

PUBLIC clga_callee
PUBLIC _clga_callee

	EXTERN     clga

.clga_callee
._clga_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,clga
	jp (hl)
	
.retaddr
		pop bc
		pop bc
		pop bc
		pop bc
.retaddr0
		ld	hl,0
		jp (hl)

