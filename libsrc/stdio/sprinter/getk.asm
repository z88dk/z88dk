;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;11/3/99 djm Saved two bytes by removing useless ld h,0
;
;
;	$Id: getk.asm,v 1.1 2002-10-01 13:53:17 dom Exp $
;


                XLIB    getk    ;Read keys



.getk
	ld	c,$31	;SCANKEY
	rst	$10
	ld	hl,0
	ret	nz	;no key pressed
	ld	l,e
	ret
