; Substitute for the z80 adc hl,hl instruction

SECTION code_crt0_sccz80
PUBLIC __z80asm__adchlhl

.__z80asm__adchlhl
		push	de

IF __CPU_INTEL__
		push	af
		ld		a, 0
		ld		d, a
		rla
		ld		e, a
		pop		af
ELSE
		ld		de, 0
		rl		e			; de = carry
ENDIF	
		add 	hl, hl
		add 	hl, de
		
		pop 	de
		ret
