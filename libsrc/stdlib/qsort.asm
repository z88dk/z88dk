
;
; $Id: qsort.asm,v 1.4 2016-03-04 23:48:13 dom Exp $
;


PUBLIC qsort
PUBLIC _qsort
EXTERN qsort_callee
EXTERN ASMDISP_QSORT_CALLEE

.qsort
._qsort
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
