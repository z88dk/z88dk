
SECTION code_driver

PUBLIC lcd_write_control
PUBLIC _lcd_write_control
PUBLIC asm_lcd_write_control

EXTERN lcd_delay_short
EXTERN LCD_CONTROL_PORT

; void lcd_write_control(byte a)
lcd_write_control:
_lcd_write_control:
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	a,l
asm_lcd_write_control:
	out	(LCD_CONTROL_PORT),a
	call	lcd_delay_short
	call	lcd_delay_short
	ret




