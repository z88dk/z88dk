;
;	System Call for REX6000
;
;
; extern INT SYSCALLEX( int, ... );

		XLIB	syscallex


; A holds the number arguments
.syscallex
	ld	b,a
	add	a,a
	ld	e,a
	ld	d,0
	ld	hl,0
	add	hl,sp
	add	hl,de	;now points to top parameter
	ld	ix,$c000	;start of variables
.lp1
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	dec	hl
	dec	hl
	dec	hl
	ld	(ix+0),e
	ld	(ix+1),d
	inc	ix
	inc	ix
	djnz	lp1	;loop round till we have to params
	rst	$10	;call the stuff
	ld	hl,($c00e)
	ret






	pop	bc
	pop	hl	;parameter
	push	hl
	push	bc
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret


