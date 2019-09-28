; Substitute for the z80 adc hl,bc instruction

SECTION code_crt0_sccz80
PUBLIC __z80asm__adchlbc

.__z80asm__adchlbc
		jr		nc, carry0
		inc 	hl
.carry0
		add 	hl, bc
		ret
