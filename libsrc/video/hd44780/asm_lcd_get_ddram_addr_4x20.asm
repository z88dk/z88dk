
SECTION code_driver

PUBLIC asm_lcd_get_ddram_addr_4x20

; Calculate DDRAM address for 4x20 HD44780 
; Row 0: 0x00 - 0x13
; Row 1: 0x40 - 0x53
; Row 2: 0x14 - 0x27
; Row 3: 0x54 - 0x67
;
; Entry: 
;   b = y
;   c = x
; Exit:
;   l = ddram address
; Preserves:
;  de
asm_lcd_get_ddram_addr_4x20:
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
	defb	$00, $40, $14, $54

