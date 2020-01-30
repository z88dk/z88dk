

	SECTION	code_graphics

	PUBLIC	commondrawr

	EXTERN	_linedraw
	EXTERN	__gfx_coords

; Common line drawing entry point
; 
;void  *(int dx, int dy) __smallc
;Note ints are actually uint8_t
;Entry: hl = drawr function
commondrawr:
	push	hl		;Function pointer
	ld	hl,__gfx_coords+2
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	hl,sp+4	; &dy
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ex	de,hl
	add	hl,bc
	push	hl		;y1
	ex	de,hl		;&dx
	ld	e,(hl)		;=dx
	inc	hl
	ld	d,(hl)
	ld	hl,__gfx_coords
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ex	de,hl
	add	hl,bc
	push	hl		;x1
	ex	de,hl		;hl=&gfx_coords+2
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	bc		;y0
	dec	hl
	dec	hl
	ld	b,(hl)
	dec	hl
	ld	c,(hl)
	push	bc		;x0
	call	_linedraw
IF __CPU_GBZ80__
        add     sp,10
ELSE
        ld      hl,10
        add     hl,sp
	ld	sp,hl
ENDIF
	ret
