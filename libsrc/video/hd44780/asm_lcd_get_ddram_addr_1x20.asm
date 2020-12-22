
SECTION code_driver

PUBLIC asm_lcd_get_ddram_addr_1x20

; Calculate DDRAM address for 1x20 HD44780
; Row 0: 0-19
;
; Entry: 
;   b = y
;   c = x
; Exit:
;   l = ddram address
; Preserves: 
;   de
asm_lcd_get_ddram_addr_1x20:
	ld	l,c
	ret
