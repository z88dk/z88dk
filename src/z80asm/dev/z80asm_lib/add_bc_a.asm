; Substitute for the z80 add bc,a instruction
; no flags are affected

SECTION code_crt0_sccz80
PUBLIC __z80asm__add_bc_a

.__z80asm__add_bc_a
		push 	af

		add 	a, c
		ld 		c, a

		ld 		a, b
		adc 	a, 0
		ld 		b, a

		pop 	af
		ret
