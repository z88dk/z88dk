
                SECTION   code_crt0_sccz80
                PUBLIC     l_mult


; Entry: hl = value1
;        de = value2
; Exit:  hl = value1 * value2

.l_mult
	ld	c,l
	ld	b,h
	defb	0xf7		; mul : hlbc = bc * de
	ld	l,c
	ld	h,b
	ret
