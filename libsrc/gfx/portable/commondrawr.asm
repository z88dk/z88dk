

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
	ld	hl,__gfx_coords
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	hl,sp+4	; &dy
	ld	a,(hl+)
	add	b
	ld	e,a
	ld	d,0
	inc	hl
	push	de
	ld	a,(hl+)	;dx
	add	c
	ld	e,a
	inc	hl
	push	de
	ld	e,b		;y0
	push	de
	ld	e,c		;x0
	push	de
	call	_linedraw
IF __CPU_GBZ80__
        add     sp,10
ELSE
        ld      hl,10
        add     hl,sp
	ld	sp,hl
ENDIF
	ret
