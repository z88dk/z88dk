
SECTION code_driver

PUBLIC asm_lcd_get_ddram_addr_gl4000

; Calculate DDRAM address for the GL4000
;
; The DDRAM addresses are a little bit mixed up,
; so just use a lookup table :(
;
; Entry: 
;   b = y
;   c = x
; Exit:
;   l = ddram address
; Preserves:
;  de
asm_lcd_get_ddram_addr_gl4000:
	ld	a,b
	and	3
	add	a	;x2
	ld	h,a
	add	a	;x4
	add	a	;x8
	add	h	;x10
	add	a	;x20
	add	c
	ld	hl,gl4000_ddram_offset
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	l,(hl)
	ret

; Offsets for all places on the screen :(
gl4000_ddram_offset:
	;Row 0
	defb 0, 1, 2, 3, 8, 9, 10, 11, 12, 13, 14, 15, 24, 25, 26, 27, 28, 29, 30, 31
	defb 64, 65, 66, 67, 72, 73, 74, 75, 76, 77, 78, 79, 88, 89, 90, 91, 92, 93, 94, 95
	defb 4, 5, 6, 7, 16, 17, 18, 19, 20, 21, 22, 23, 32, 33, 34, 35, 36, 37, 38, 39
	defb 68, 69, 70, 71, 80, 81, 82, 83, 84, 85, 86, 87, 96, 97, 98, 99, 100, 101, 102, 103

