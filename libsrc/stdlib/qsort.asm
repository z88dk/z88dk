
;
; $Id: qsort.asm,v 1.3 2015-01-19 01:33:22 pauloscustodio Exp $
;


PUBLIC qsort
EXTERN qsort_callee
EXTERN ASMDISP_QSORT_CALLEE

.qsort
	pop	af
	pop	ix	; *compar
	pop	hl	; width
	pop de	; nel
	pop bc	; base
	
	; __CALLEE__
	push bc
	push de
	push hl
	push ix
	push af

	jp qsort_callee + ASMDISP_QSORT_CALLEE
