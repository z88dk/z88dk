

	SECTION	code_graphics

	PUBLIC	commondraw

	EXTERN	_linedraw

; Common line drawing entry point
; 
;void  *(int x, int y, int x2, int y2) __smallc
;Note ints are actually uint8_t
;Entry: hl = draw function
commondraw:
	push	hl		;Function pointer
	ld	hl,sp+4	; &y2
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	ld	e,(hl)	;x2
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	ld	e,(hl)	;y
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	ld	e,(hl)	;x
	inc	hl
	ld	d,(hl)
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
