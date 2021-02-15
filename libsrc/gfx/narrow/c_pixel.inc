	INCLUDE	"graphics/grafix.inc"
	EXTERN	plotpixel
	EXTERN	respixel
	EXTERN	xorpixel
	EXTERN	pointxy

; ******************************************************************
;
; Plot etc pixel at (x,y) coordinate. Chunky graphics
; Entry h = x
;       l = y
;
	ld	a,h
	cp	maxx / 4
	ret	nc
	ld	a,l
	cp	maxy / 4
	ret	nc
IF __CPU_INTEL__
	rlca
	rlca
	and	@11111100
	ld	l,a
	ld	a,h
	rlca
	rlca
	and	@11111100
	ld	h,a
ELSE
	sla	h
	sla	h
	sla	l
	sla	l	
ENDIF
	ld	c,4
row_loop:
	push	hl
	ld	b,4
col_loop:
	push	bc
	push	hl
IF NEEDplot
	call	plotpixel
ENDIF
IF NEEDunplot
	call	respixel
ENDIF
IF NEEDxor
	call	xorpixel
ENDIF
IF NEEDpoint
	call	pointxy
	jr	z,failed
ENDIF
	pop	hl
	inc	h
	pop	bc
	djnz	col_loop
	pop	hl
	inc	l
	dec	c
	jr	nz,row_loop
IF NEEDpoint
	inc	c
ENDIF
	ret

IF NEEDpoint
; Fz is set
failed:
        pop     hl
        pop     bc
        pop     hl
        ret
ENDIF

