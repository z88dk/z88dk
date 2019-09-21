; Substitute for the z80 adc hl,bc instruction

SECTION code_crt0_sccz80
PUBLIC __z80asm__adc_hl_bc

.__z80asm__adc_hl_bc
		push 	af
		ld 		a, l
		adc 	a, 0
		ld 		l, a
		
		ld  	a, h
		adc 	a, 0
		ld 		h, a
		
		pop 	af
		
		add 	hl, bc
	
		ret
