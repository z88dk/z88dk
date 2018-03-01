;
;       Kaypro ('83 versions) pseudo graphics routines
;	Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;       Xor pixel at (x,y) coordinate.
;
;
;	$Id: xorpixl_83.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib
			PUBLIC	xorpixel

			EXTERN	plot_end_83
			EXTERN	plot_decode_83

.xorpixel
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range

			push	bc

			call plot_decode_83
			
			jr  c,odd
			xor 1
			jr  even
.odd
			xor 2
.even
			jp plot_end_83
