	INCLUDE	"graphics/grafix.inc"

	EXTERN	w_plotpixel
	EXTERN	w_respixel
	EXTERN	w_xorpixel
	EXTERN	w_pointxy

; ******************************************************************
;
; Plot etc pixel at (x,y) coordinate (chunky for wide screens)
; Entry h = x
;       l = y
;
IF maxx / 4 < 256 && maxy / 4 < 256

IF maxx / 4 <> 256
	ld	a,h
	cp	maxx / 4
	ret	nc
ENDIF
IF maxx / 4 <> 256
	ld	a,l
	cp	maxy / 4
	ret	nc
ENDIF
	ex	de,hl
	ld	l,e
	ld	h,0
	add	hl,hl
	add	hl,hl		;y * 4
	ex	de,hl
	ld	l,h
	ld	h,0
	add	hl,hl
	add 	hl,hl		;x * 4


	; hl = x
	; de = y

	ld	c,4
row_loop:
	push	hl
	ld	b,4
col_loop:
	push	bc
	push	hl
	push	de
IF NEEDplot
	call	w_plotpixel
ENDIF
IF NEEDunplot
	call	w_respixel
ENDIF
IF NEEDxor
	call	w_xorpixel
ENDIF
IF NEEDpoint
	call	w_pointxy
	jr	z,failed
ENDIF
	pop	de
	pop	hl
	inc	hl
	pop	bc
	djnz	col_loop
	pop	hl
	inc	de
	dec	c
	jr	nz,row_loop
IF NEEDpoint
	inc	c
ENDIF
	ret

IF NEEDpoint
; Fz is set
failed:
	pop	bc
        pop     bc
        pop     bc
        pop     bc
        ret
ENDIF

ENDIF
