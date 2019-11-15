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
IF FORgamegear
	ld	a,3*8
	add (hl)		; Y
	ld	b,a
ELSE
	ld	b, (hl)		; Y
ENDIF
	inc	hl
	inc	hl
IF FORgamegear
	ld	a,6*8
	add (hl)		; X
	ld	c,a
ELSE
	ld	c, (hl)		; X
ENDIF
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
	nop			;4
	nop
	nop
	nop
	nop
	nop
	ld a, d			;4
	out ($be), a		; Set Tile

	ret
