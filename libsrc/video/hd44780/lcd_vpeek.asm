
SECTION code_driver

PUBLIC lcd_vpeek
PUBLIC _lcd_vpeek

PUBLIC asm_lcd_vpeek

EXTERN __console_x

EXTERN asm_lcd_get_vram_addr

lcd_vpeek:
_lcd_vpeek:
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	bc,(__console_x)
	ld	a,l
	call	asm_lcd_vpeek
	ld	l,a
	ld	h,0
	ret

; Entry:
; a = character
; b = y
; c = x
asm_lcd_vpeek:
	; First of all, put onto the VRAM map
	call	asm_lcd_get_vram_addr
	ld	a,(hl)
	and	a
	ret

