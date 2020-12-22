

SECTION code_driver

PUBLIC asm_lcd_get_vram_addr

EXTERN LCD_VRAM
EXTERN CONSOLE_ROWS
EXTERN CONSOLE_COLUMNS

; Get the address of the char location in the VRAM
; Entry: c = x
;        b = y
; Exit: hl = vram address
;
; Preserves: de
asm_lcd_get_vram_addr:
	push	de
	ld	hl,LCD_VRAM - CONSOLE_COLUMNS	
	ld	de,CONSOLE_COLUMNS
	inc	b
loop1:
	add	hl,de
	djnz	loop1
	add	hl,bc
	pop	de
	ret
