; Substitute for the z80 adc hl,de instruction

SECTION code_crt0_sccz80
PUBLIC __z80asm__adchlde

.__z80asm__adchlde
		jr		nc, carry0
		inc 	hl
.carry0
		add 	hl, de
		ret
