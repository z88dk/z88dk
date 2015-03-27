;       Small C+ Math Library
;       General "fudging routine"

                PUBLIC    addhalf

		EXTERN	hladd


.addhalf
	ld	hl,half
	jp	hladd


.half   DEFB    0,0,0,0,0,$80   ;0.5
