;
;       Kaypro ('83 versions) pseudo graphics routines
;	Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: plotpixl_83.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib
			PUBLIC	plotpixel

			EXTERN	plot_end_83
			EXTERN	plot_decode_83

.plotpixel
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range

			push	bc

			call plot_decode_83
			
			jr  c,odd
			or  1
			jr  even
.odd
			or  2
.even
			jp	plot_end_83
