	INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
	PUBLIC	c_respixel


	EXTERN	respixel

; ******************************************************************
;
; Plot pixel at (x,y) coordinate. Chunky graphics
;
.c_respixel
	ld	a,h
	cp	maxx / 4
	ret	nc
	ld	a,l
	cp	maxy / 4
	ret	nc

	sla	h
	sla	h
	sla	l
	sla	l	
	ld	c,4
row_loop:
	push	hl
	ld	b,4
col_loop:
	push	bc
	push	hl
	call	respixel
	pop	hl
	inc	h
	pop	bc
	djnz	col_loop
	pop	hl
	inc	l
	dec	c
	jr	nz,row_loop
	ret

