;       Small C+ Math Library
;       General "fudging routine"

                XLIB    addhalf

		LIB	hladd


.addhalf
	ld	hl,half
	jp	hladd


.half   DEFB    0,0,0,0,0,$80   ;0.5
