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
.LoadPalette1
	; --BBGGRR
	ld	a,(hl)		;7
	
	; GGGGRRRR ----BBBB
	ld d,a
	ld e,0
	
	rra
	rr e
	rra
	rr e
	
	rr e
	rr e
	
	rra
	rr e
	rra
	rr e

	ld	a,e
	out	($be),a

	ld	a,d
	rra
	rra
	and @00001100
	
	out	($be),a
	
	inc	hl		;6
	nop			;4
	djnz	LoadPalette1	;13
	ret
