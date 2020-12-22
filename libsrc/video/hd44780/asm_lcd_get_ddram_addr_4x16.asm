
SECTION code_driver

PUBLIC asm_lcd_get_ddram_addr_4x16

; Calculate DDRAM address for 4x16 HD44780
; Row 0: 0x00 - 0x0f
; Row 1: 0x40 - 0x4f
; Row 2: 0x10 - 0x1f
; Row 3: 0x50 - 0x5f
;
; Entry: 
;   b = y
;   c = x
; Exit:
;   l = ddram address
; Preserves:
;  de
asm_lcd_get_ddram_addr_4x16:
	ld	hl,hd44780_4x20_rows
row_inc:
	ld	a,(hl)
	inc	hl
	djnz	row_inc
	add	c
	ld	l,a
	ret

; Offsets for the start of each row
hd44780_4x20_rows:
	defb	$00, $40, $10, $50

