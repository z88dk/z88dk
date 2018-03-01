;
;       Kaypro ('83 versions) pseudo graphics routines
;	Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;       Reset pixel at (x,y) coordinate.
;
;
;	$Id: respixl_83.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib
			PUBLIC	respixel

			EXTERN	plot_end_83
			EXTERN	plot_decode_83

.respixel
			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range

			push	bc

			call plot_decode_83
			
			jr  c,odd
			and $FE
			jr  even
.odd
			and $FD
.even
			jp plot_end_83
