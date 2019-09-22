; Substitute for the z80 adc hl,bc instruction

SECTION code_crt0_sccz80
PUBLIC __z80asm__adchlbc

.__z80asm__adchlbc
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
