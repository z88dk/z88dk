

IF __CPU_GBZ80__ || __CPU_INTEL__
;---------------------------------------------


ELSE
;---------------------------------------------

SECTION code_clib

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

ENDIF
