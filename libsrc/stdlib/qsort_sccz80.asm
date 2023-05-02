
;
; $Id: qsort.asm $
;


SECTION code_clib

PUBLIC qsort_sccz80
PUBLIC _qsort_sccz80

EXTERN qsort_sccz80_enter
EXTERN l_setix

.qsort_sccz80
._qsort_sccz80
	pop	af

IF __CPU_GBZ80__ || __CPU_INTEL__
	pop	hl	; *compar
    call l_setix
ELSE
	pop	ix	; *compar
ENDIF

	pop	hl	; width
	pop de	; nel
	pop bc	; base
	
	; __CALLEE__
	push bc
	push de
	push hl

	push hl

	push af

	jp qsort_sccz80_enter

