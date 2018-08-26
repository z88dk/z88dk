;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;11/3/99 djm Saved two bytes by removing useless ld h,0
;
;
;	$Id: getk.asm,v 1.3 2016-03-13 18:14:13 dom Exp $
;


		SECTION	  code_clib
                PUBLIC    getk    ;Read keys



.getk
	push	ix
	ld	c,$31	;SCANKEY
	rst	$10
	pop	ix
	ld	hl,0
	ret	z	;no key pressed
	
IF STANDARDESCAPECHARS
	ld	a,13
	cp	e
	jr	nz,not_return
	ld	e,10
.not_return
ENDIF
	ld	l,e
	ret
