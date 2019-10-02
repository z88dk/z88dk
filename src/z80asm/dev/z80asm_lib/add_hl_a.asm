; Substitute for the z80 add hl,a instruction
; no flags are affected

SECTION code_crt0_sccz80
PUBLIC __z80asm__add_hl_a

.__z80asm__add_hl_a
		push 	af

		add 	a, l
		ld 		l, a

		ld 		a, h
		adc 	a, 0
		ld 		h, a

		pop 	af
		ret
