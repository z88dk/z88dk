;
;	System Call for REX6000
;
;
; extern ULONG SYSCALLEX( int, ... );

		XLIB	syscallexl


; A holds the number arguments
.syscallexl
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
	ld	de,($c010)	;who knows!
	ret

