;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;11/3/99 djm Saved two bytes by removing useless ld h,0
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;


                PUBLIC    getk    ;Read keys



.getk
	ld	c,$31	;SCANKEY
	rst	$10
	ld	hl,0
	ret	nz	;no key pressed
	ld	l,e
	ret
