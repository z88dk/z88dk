;
;	output8 - write out to a port
;
;	djm 7/3/2001
;

	PUBLIC output8
	PUBLIC _output8


.output8
._output8
	pop hl
	pop de		;value
	pop bc		;port
	push bc
	push de
	push hl
	ld a,e
	out (c),a
	ld l,a
	ld h,0
	ret

