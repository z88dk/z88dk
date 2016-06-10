	SECTION code_clib	
	PUBLIC	set_sprite
	PUBLIC	_set_sprite

;==============================================================
; set_sprite(int n, int x, int y, int tile)	
;==============================================================
; Loads the specified tileset into VRAM
;==============================================================
.set_sprite
._set_sprite
	ld	hl, 2
	add	hl, sp
	ld	d, (hl)		; Tile
	inc	hl
	inc	hl
	ld	b, (hl)		; Y
	inc	hl
	inc	hl
	ld	c, (hl)		; X
	inc	hl
	inc	hl
	ld	e, (hl)		; N
	
	;vdp set addr (Y table)
	ld	a, e
	out	($bf), a
	ld	a, $7f
	out	($bf), a
	
	ld	a, b
	out	($be), a	; Set Y
	
	;vdp set addr (X/Tile table)
	ld	a, e
	add	a, a
	or	$80
	out	($bf), a
	ld	a, $7f
	out	($bf), a

	ld a, c
	out ($be), a		; Set X
	ld a, d
	out ($be), a		; Set Tile

	ret
