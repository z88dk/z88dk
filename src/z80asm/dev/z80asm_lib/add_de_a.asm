; Substitute for the z80 add de,a instruction
; no flags are affected

SECTION code_crt0_sccz80
PUBLIC __z80asm__add_de_a

.__z80asm__add_de_a
		push 	af
		
		add 	a, e
		ld 		e, a
		
		ld 		a, d
		adc 	a, 0
		ld 		d, a
		
		pop 	af
		ret
