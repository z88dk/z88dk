;
;	Z80 Runtime Library
;
;	Signed integer compare
;
;	$Id: l_cmp.asm,v 1.6 2002-02-17 10:39:24 dom Exp $:


                XLIB    l_cmp

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
	jr	nz,l_cmp1
	ld	a,e
	cp	l
.l_cmp1
	ld	hl,1
	ret
