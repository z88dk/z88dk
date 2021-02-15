
SECTION code_driver

PUBLIC lcd_putchar
PUBLIC _lcd_putchar

PUBLIC asm_lcd_putchar

EXTERN __console_x
EXTERN asm_lcd_get_ddram_addr

EXTERN asm_lcd_get_vram_addr
EXTERN asm_lcd_write_control
EXTERN asm_lcd_write_data

INCLUDE "hd44780.def"

lcd_putchar:
_lcd_putchar:
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	bc,(__console_x)
	ld	a,l
; a = character
; b = y
; c = x
asm_lcd_putchar:
	push	af
	ld	d,a
	push	bc
	; First of all, put onto the VRAM map
	call	asm_lcd_get_vram_addr
	ld	(hl),d
	pop	bc
	call	asm_lcd_get_ddram_addr
        ld      a,LCD_SETDDRAMADDR
        or      l
        call    asm_lcd_write_control
        pop     af
        call    asm_lcd_write_data
	ret
