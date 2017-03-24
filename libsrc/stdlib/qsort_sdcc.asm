
;
; $Id: qsort.asm,v 1.4 2016-03-04 23:48:13 dom Exp $
;


PUBLIC qsort_sdcc
PUBLIC _qsort_sdcc

EXTERN qsort_sdcc_enter

.qsort_sdcc
._qsort_sdcc

   pop af
	pop bc
	exx
	pop hl
	pop de
	pop bc
	
	push bc
	push de
	push hl
	exx
	push bc
	push af

	jp qsort_sdcc_enter
