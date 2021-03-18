;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;

;
;	$Id: w_setxy.asm $
;

;
; fake w_setxy calling a function written in C
; 


SECTION code_graphics

PUBLIC     w_setxy
EXTERN    setxy

.w_setxy
IF !__CPU_INTEL__
	push ix
	exx
	push bc
	push hl
	push de
	exx
ENDIF
	push bc
	push hl
	push de
	
	call setxy
	
	pop de
	pop hl
	pop bc
IF !__CPU_INTEL__
	exx
	pop de
	pop hl
	pop bc
	exx
	pop ix
ENDIF
	ret
