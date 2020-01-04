;
; Clear hires graphics screen
;

	SECTION	  code_clib
        PUBLIC    clg
        PUBLIC    _clg
		
        EXTERN     swapgfxbk
        EXTERN    swapgfxbk1

        defc	TEXT_DISPLAY = 0xf3c8


.clg
._clg

	ld a,($E6A7)		; CursorMode
	res	0,a				; hide cursor
	ld ($E6A7),a
	or	$80				; complete CRTC command for cursor mode
	ld ($E6A8),a		; CursorCommand

	ld	hl, TEXT_DISPLAY
	ld	de,120
	ld	c,25
cls_1:
	push	hl
	ld	b,80
cls_2:
	ld	(hl),' '
	inc	hl
	djnz	cls_2
	ld	b,40
cls_3:
	ld	(hl),0
	inc	hl
	djnz	cls_3
	pop	hl
	add	hl,de
	dec	c
	jr	nz,cls_1

	call swapgfxbk
	call clearpage	; green plane
	out ($5d),a
	call clearpage	; red plane
	out ($5c),a
	call clearpage	; blue plane
	

	jp swapgfxbk1

	
.clearpage
		
	ld	hl,0
	ld	d,h
	ld	e,h
	ld	b,h
	di
	add	hl,sp
	ld	sp,$FFFF
.clgloop
	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	push	de
	push	de
	push	de
	push	de

	djnz	clgloop

	ld	sp,hl
	ret
