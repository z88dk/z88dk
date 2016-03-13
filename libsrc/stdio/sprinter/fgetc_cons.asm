;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;22/3/2000 - This was getkey() renamed to getchar
;
;1/4/2000  - Renamed to fgetc_cons
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-03-13 18:14:13 dom Exp $
;

		SECTION	  code_clib

                PUBLIC    fgetc_cons


.fgetc_cons
	push	ix
	ld	b,$30		;WAITKEY
	ld	c,$35		;K_CLEAR
	rst	$10
	pop	ix
	ld	l,e		;e= = ascii code
	ld	h,0
	ret
