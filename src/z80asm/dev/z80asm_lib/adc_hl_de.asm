; Substitute for the z80 adc hl,de instruction

SECTION code_crt0_sccz80
PUBLIC __z80asm__adc_hl_de

.__z80asm__adc_hl_de
		push 	af
		ld 		a, l
		adc 	a, 0
		ld 		l, a
		
		ld  	a, h
		adc 	a, 0
		ld 		h, a
		
		pop 	af
		
		add 	hl, de
	
		ret
