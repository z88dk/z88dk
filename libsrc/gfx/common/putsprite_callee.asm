;
;  Generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ putsprite(int ortype, int x, int y, void *sprite);
;
;
;	$Id: putsprite_callee.asm $
;

IF !__CPU_GBZ80__
SECTION code_graphics
PUBLIC putsprite_callee
PUBLIC _putsprite_callee

	EXTERN    putsprite
	EXTERN	   __graphics_retaddr

.putsprite_callee
._putsprite_callee
	ld	hl,retaddr
	ex	(sp),hl
	ld	(__graphics_retaddr),hl
	ld	hl,putsprite
	jp (hl)
	
.retaddr
    pop bc ; *sprite
    pop bc
    pop bc
    pop bc	; ortype
    ld	hl,(__graphics_retaddr)
    jp (hl)


ENDIF
