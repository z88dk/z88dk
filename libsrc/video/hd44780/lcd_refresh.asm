
SECTION code_driver

PUBLIC lcd_refresh
PUBLIC _lcd_refresh
PUBLIC asm_lcd_refresh

EXTERN asm_lcd_write_control
EXTERN asm_lcd_write_data
EXTERN asm_lcd_get_ddram_addr

EXTERN CONSOLE_ROWS
EXTERN CONSOLE_COLUMNS

EXTERN LCD_CONTROL_PORT
EXTERN LCD_DATA_PORT

EXTERN LCD_VRAM

INCLUDE "hd44780.def"

lcd_refresh:
_lcd_refresh:
asm_lcd_refresh:
	ld	a,+(LCD_DISPLAYCONTROL|LCD_DISPLAYON|LCD_CURSOROFF|LCD_BLINKOFF)
	call	asm_lcd_write_control

	ld	de,LCD_VRAM
	ld	b,0	;y
loop:
	ld	c,0	;x
loop2:
	push	bc
	call	asm_lcd_get_ddram_addr	;Machine specific
	ld	a,LCD_SETDDRAMADDR
	or	l
	call	asm_lcd_write_control
	ld	a,(de)
	inc	de
	push	de
	call	asm_lcd_write_data
	pop	de
	pop	bc
	inc	c
	ld	a,CONSOLE_COLUMNS
	cp	c
	jr	nz,loop2
	inc	b
	ld	a,CONSOLE_ROWS
	cp	b
	jr	nz,loop
	ret
