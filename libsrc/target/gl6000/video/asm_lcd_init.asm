
SECTION code_driver
PUBLIC asm_lcd_init


asm_lcd_init:
	ld	a,$83
	out	($31),a
	out	($31),a
	ret
