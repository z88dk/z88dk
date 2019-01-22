;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ putsprite(int ortype, int x, int y, void *sprite);
;
;
;	$Id: putsprite_callee.asm $
;

SECTION smc_clib

PUBLIC putsprite_callee
PUBLIC _putsprite_callee

	EXTERN     putsprite

.putsprite_callee
._putsprite_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,putsprite
	jp (hl)
	
.retaddr
		pop bc ; *sprite
		pop bc
		pop bc
		pop bc	; ortype
.retaddr0
		ld	hl,0
		jp (hl)

