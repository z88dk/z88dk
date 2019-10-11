;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_ucmp

; unsigned compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero

.l_ucmp
	ld	a,d
	cp	h
	ret	nz
	ld	a,e
	cp	l
	ret
