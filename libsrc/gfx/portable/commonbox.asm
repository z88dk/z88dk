

	SECTION	code_graphics

	PUBLIC	commonbox

	EXTERN	_boxdraw

; Common line drawing entry point
; 
;void  *(int x, int y, int w, int h __smallc
;Note ints are actually uint8_t
;Entry: hl = draw function
commonbox:
	push	hl		;Function pointer
	ld	hl,sp+4	; &h
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	ld	e,(hl)	;w
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
	call	_boxdraw
IF __CPU_GBZ80__
	add	sp,10
ELSE
	ld	hl,10
	add	hl,sp
	ld	sp,hl
ENDIF
	ret
