
SECTION code_driver

PUBLIC asm_lcd_get_ddram_addr_2x20

; Calculate DDRAM address for 2x20 HD44780 (also 2x16)
; Row 0: 0-19
; Row 1: 64 - 83
;
; Entry: 
;   b = y
;   c = x
; Exit:
;   l = ddram address
; Preserves:
;   de
asm_lcd_get_ddram_addr_2x20:
	ld	a,b		;*64
	rrca
	rrca
	and	@01000000
	add	c
	ld	l,a
	ret



	


