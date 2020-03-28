

	SECTION	code_graphics

	PUBLIC	commoncircle

	EXTERN	_circledraw

; Common line drawing entry point
; 
;void  *(int x, int y, int radius, int skip) __smallc
;Note ints are actually uint8_t
;Entry: hl = draw function
commoncircle:
	push	hl		;Function pointer
	ld	hl,sp+4	; &skip
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	ld	e,(hl)	;radius
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
	call	_circledraw
IF __CPU_GBZ80__
        add     sp,10
ELSE
        ld      hl,10
        add     hl,sp
	ld	sp,hl
ENDIF
	ret
