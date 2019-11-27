; Substitute for the z80 adc hl,sp instruction

SECTION code_crt0_sccz80
PUBLIC __z80asm__adc_hl_sp

.__z80asm__adc_hl_sp
		jr		nc, carry0
		inc 	hl
.carry0
		inc 	hl			; compensate for return address on the stack
		inc		hl
		
		add 	hl, sp
		ret
