
SECTION code_driver

PUBLIC lcd_scrollup
PUBLIC _lcd_scrollup

PUBLIC asm_lcd_scrollup

EXTERN asm_lcd_refresh

EXTERN LCD_VRAM
EXTERN CONSOLE_COLUMNS
EXTERN CONSOLE_ROWS


lcd_scrollup:
_lcd_scrollup:
asm_lcd_scrollup:
	push	de
	push	bc

	ld	hl,+(LCD_VRAM + CONSOLE_COLUMNS)
	ld	de,LCD_VRAM
	ld	bc,+(CONSOLE_COLUMNS * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
	ld	a,0x20
clear1:
	ld	(hl),a
	inc	hl
	djnz	clear1
	call	asm_lcd_refresh
        pop     bc
        pop     de
	ret
