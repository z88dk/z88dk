;
;	input8 - read in from a port
;
;	djm 7/3/2001
;

	PUBLIC input8
	PUBLIC _input8


.input8
._input8
	pop hl
	pop bc
	push bc
	push hl
	in a,(c)
	ld l,a
	ld h,0
	ret

