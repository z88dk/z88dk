;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.6 2016-07-20 05:45:02 stefano Exp $
;

        SECTION code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	ATTR
	
	EXTERN	ansicolumns	


.ansi_SCROLLUP
	ld	de,$3000
	ld	bc,ansicolumns*24
	
	ld	a,ansicolumns
	
	ld	h,d
	ld	l,a
	push af
	cp	80
	jr	nz,outldir1
	rl	c
	rl	b
.outldir1
	push bc
	ld b,h
	ld c,l
	in a,(c)
	ld b,d
	ld c,e
	out (c),a
	ld b,h
	ld c,l
	res	4,b
	in a,(c)
	ld b,d
	ld c,e
	res	4,b
	out (c),a
	pop bc
	inc hl
	inc de
	dec bc
	ld	a,b
	or	c
	jr	nz,outldir1
	
	ld	h,d
	ld	l,e
	pop	af
	ld	b,a

.reslloop
	push bc
	ld b,h
	ld c,l
	ld	a,32
	out	(c),a
	res	4,b
	ld	a,(ATTR+1)
	out	(c),a
	pop bc
	inc	hl
	djnz	reslloop
	ret

