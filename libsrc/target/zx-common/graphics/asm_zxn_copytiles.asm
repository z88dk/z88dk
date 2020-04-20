IF FORzxn

	MODULE		asm_zxn_copytiles

	SECTION		code_graphics

	PUBLIC		asm_zxn_copytiles

	; Used to determine which palette index is set
	EXTERN		__CLIB_TILES_PALETTE_SET_INDEX

; Copy a standard 8x8 font/graphics into the tile description
;
; Entry: hl = font
;	  c = starting tile
;	  b = number of tiles
;
; We use palette index 0 and 1 to represent set bits
asm_zxn_copytiles:
	ex	de,hl
	ld	l,c
	push	bc
	ld	a,$6f
	ld	bc,0x243b
	out	(c),a
	inc	b
	in	b,(c)
	ld	c,0
	; Get the tile position (starting tile *32)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,bc	;Add on tiledefinition address
	ex	de,hl	;de = tilemaps, hl = font
	pop	bc

loop_char:
	push	bc

	ld	b,8
loop:
	ld	c,(hl)

	xor	a	;Default value
	rlc	c
	jr	nc,notset_7
	ld	a,+(__CLIB_TILES_PALETTE_SET_INDEX << 4)
notset_7:
	rlc	c
	jr	nc,notset_6
	or	__CLIB_TILES_PALETTE_SET_INDEX
notset_6:
	ld	(de),a
	inc	de

	xor	a	;Default value
	rlc	c
	jr	nc,notset_5
	ld	a,+(__CLIB_TILES_PALETTE_SET_INDEX << 4)
notset_5:
	rlc	c
	jr	nc,notset_4
	or	__CLIB_TILES_PALETTE_SET_INDEX
notset_4:
	ld	(de),a
	inc	de

	xor	a	;Default value
	rlc	c
	jr	nc,notset_3
	ld	a,+(__CLIB_TILES_PALETTE_SET_INDEX << 4)
notset_3:
	rlc	c
	jr	nc,notset_2
	or	__CLIB_TILES_PALETTE_SET_INDEX
notset_2:
	ld	(de),a
	inc	de

	xor	a	;Default value
	rlc	c
	jr	nc,notset_1
	ld	a,+(__CLIB_TILES_PALETTE_SET_INDEX << 4)
notset_1:
	rlc	c
	jr	nc,notset_0
	or	__CLIB_TILES_PALETTE_SET_INDEX
notset_0:
	ld	(de),a
	inc	de
	inc	hl
	djnz	loop
	pop	bc
	djnz	loop_char
	ret
ENDIF
