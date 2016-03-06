;
;	Z80 Runtime Library
;
;	Signed integer compare
;
;	$Id: l_cmp.asm,v 1.9 2016-03-06 21:35:27 dom Exp $:


                SECTION   code_crt0_sccz80
                PUBLIC    l_cmp

; signed compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
.l_cmp
	ld	a,h
	add	$80
	ld	b,a
	ld	a,d
	add	$80
	cp	b
	ret	nz
	ld	a,e
	cp	l
	ret
