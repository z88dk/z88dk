	
	SECTION code_clib
	PUBLIC	clear_vram
	PUBLIC	_clear_vram
	EXTERN	VRAMToHL
	
;==============================================================
; Clear VRAM
;==============================================================
; Sets all of VRAM to zero
;==============================================================
.clear_vram
._clear_vram
	ld	hl,$0000
	call	VRAMToHL
	; Output 16KB of zeroes
	ld 	hl, $4000    ; Counter for 16KB of VRAM
	ld 	a, $00       ; Value to write
.clearVRAM1
	out 	($be),a      ; Output to VRAM address, which is auto-incremented after each write
	dec 	h
	jp 	nz, clearVRAM1
	dec 	l
	jp 	nz, clearVRAM1
	ret
