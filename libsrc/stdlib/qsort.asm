
;
; $Id: qsort.asm,v 1.2 2010-11-03 10:03:49 stefano Exp $
;


XLIB qsort
LIB qsort_callee
XREF ASMDISP_QSORT_CALLEE

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
