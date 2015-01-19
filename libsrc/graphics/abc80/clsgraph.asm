;
;       ABC80 Graphics Functions
;
;       clg ()  -- clear screen and init graphics
;
;	routine found in "grafik.asm"
;	by Bengt Holgersson - 1986-03-13 22.58.30
;
;       imported by Stefano Bodrato - 29/12/2006  :o)
;
;
;       $Id: clsgraph.asm,v 1.2 2015-01-19 01:32:45 pauloscustodio Exp $
;


		PUBLIC    cleargraphics

.cleargraphics
		ld	ix,884
		ld	b,24
grloop:		push	bc
		ld	l,(ix+0)
		ld	h,(ix+1)
		ld	(hl),23
		inc	hl
		ld	(hl),32
		ld	d,h
		ld	e,l
		inc	de
		ld	a,(590)
		dec	a
		ld	b,0
		ld	c,a
		ldir
		inc	ix
		inc	ix
		pop	bc
		djnz	grloop
		ret
