
;
; $Id: qsort.asm,v 1.4 2016-03-04 23:48:13 dom Exp $
;


PUBLIC qsort_sccz80
PUBLIC _qsort_sccz80

EXTERN qsort_sccz80_enter

.qsort_sccz80
._qsort_sccz80
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

	jp qsort_sccz80_enter
