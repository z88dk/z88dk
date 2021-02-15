

SECTION code_driver

PUBLIC lcd_clear
PUBLIC _lcd_clear
PUBLIC asm_lcd_clear

EXTERN asm_lcd_delay_long

EXTERN LCD_DATA_PORT
EXTERN LCD_CONTROL_PORT

EXTERN CONSOLE_COLUMNS
EXTERN CONSOLE_ROWS
EXTERN LCD_VRAM

EXTERN asm_lcd_write_control

EXTERN __console_x
EXTERN __console_y

INCLUDE "hd44780.def"

lcd_clear:
_lcd_clear:
asm_lcd_clear:
	ld	a,LCD_CLEARDISPLAY
	call	asm_lcd_write_control
	ld	a,LCD_RETURNHOME
	call	asm_lcd_write_control
	call	asm_lcd_delay_long
	xor	a
	ld	(__console_x),a
	ld	(__console_y),a
	ld	hl,LCD_VRAM
	ld	bc,+(CONSOLE_COLUMNS * CONSOLE_ROWS)
clear1:
	ld	(hl),0x20
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,clear1
	ret
