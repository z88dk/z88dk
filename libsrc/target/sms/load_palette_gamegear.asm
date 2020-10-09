	SECTION code_clib	
	PUBLIC	load_palette_gamegear
	PUBLIC	_load_palette_gamegear
	PUBLIC	asm_load_palette_gamegear

;==============================================================
; void load_palette(int *data, int index, int count)
;==============================================================
; C interface for LoadPalette
;==============================================================
.load_palette_gamegear
._load_palette_gamegear
	ld	hl, 2
	add	hl, sp
	ld	b, (hl)
	inc 	hl
	inc	hl
	ld	a, (hl)
	add	a
	ld	c,a
	inc	hl
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	; falls through to LoadPalette

;==============================================================
; Load palette
;==============================================================
; Parameters:
; hl = location
; b  = number of values to write
; c  = palette index to start at (<64)
;==============================================================
.asm_load_palette_gamegear
	ld 	a,c
	out 	($bf),a     ; Palette index
	ld 	a,$c0
	out 	($bf),a     ; Palette write identifier
	inc	c
	; GGGGRRRR
	ld	e,(hl)		;7
	inc	hl
        ; 0000BBBB
	ld	d,(hl)
	
	ld	a,e
	out	($be),a
	ld 	a,c
	out 	($bf),a     ; Palette index
	ld 	a,$c0
	out 	($bf),a     ; Palette write identifier
	inc	c
        nop
        nop
	ld	a,d
	out	($be),a
	
	inc	hl		;6
	nop			;4
	djnz	asm_load_palette_gamegear ;13
	ret
