

	SECTION	code_graphics

	PUBLIC	commondrawto

	EXTERN	_linedraw

	EXTERN	__gfx_coords

; Common line drawing entry point
; 
;void  *(int x2, int y2) __smallc
;Note ints are actually uint8_t
;Entry: hl = drawto function
commondrawto:
	push	hl		;Function pointer
	ld	hl,sp+4	
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de		;y2
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de		;x2
	ld	hl,__gfx_coords+3
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
	dec	hl
	push	de		;y0
	ld	d,(hl)
	dec	hl
	ld	e,(hl)
	push	de		;x0
	call	_linedraw
IF __CPU_GBZ80__
        add     sp,10
ELSE
        ld      hl,10
        add     hl,sp
	ld	sp,hl
ENDIF
	ret
