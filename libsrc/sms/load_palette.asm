	SECTION code_clib	
	PUBLIC	load_palette
	PUBLIC	_load_palette

;==============================================================
; void load_palette(unsigned char *data, int index, int count)
;==============================================================
; C interface for LoadPalette
;==============================================================
.load_palette
._load_palette
	ld	hl, 2
	add	hl, sp
	ld	b, (hl)
	inc 	hl
	inc	hl
	ld	c, (hl)
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
; c  = palette index to start at (<32)
;==============================================================
.LoadPalette
	ld 	a,c
	out 	($bf),a     ; Palette index
	ld 	a,$c0
	out 	($bf),a     ; Palette write identifier
	ld 	c,$be
	otir                ; Output b bytes starting at hl to port c
	ret
