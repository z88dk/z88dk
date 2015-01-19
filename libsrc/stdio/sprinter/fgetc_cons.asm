;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;22/3/2000 - This was getkey() renamed to getchar
;
;1/4/2000  - Renamed to fgetc_cons
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;


                PUBLIC    fgetc_cons


.fgetc_cons
	ld	b,$30		;WAITKEY
	ld	c,$35		;K_CLEAR
	rst	$10
	ld	l,e		;e= = ascii code
	ld	h,0
	ret
