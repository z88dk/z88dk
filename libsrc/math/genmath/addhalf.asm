;       Small C+ Math Library
;       General "fudging routine"


	SECTION   code_fp
        PUBLIC    addhalf

	EXTERN	hladd


.addhalf
	ld	hl,half
	jp	hladd

		SECTION rodata_fp
.half   DEFB    0,0,0,0,0,$80   ;0.5
