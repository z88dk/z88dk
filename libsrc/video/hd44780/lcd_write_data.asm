
SECTION code_driver

PUBLIC lcd_write_data
PUBLIC _lcd_write_data
PUBLIC asm_lcd_write_data

EXTERN lcd_delay_short
EXTERN LCD_DATA_PORT

; void lcd_write_data(byte a)
lcd_write_data:
_lcd_write_data:
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	a,l
asm_lcd_write_data:
	out	(LCD_DATA_PORT),a
	call	lcd_delay_short
	ret




