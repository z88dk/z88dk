;
;       Kaypro ('83 versions) pseudo graphics routines
;	Version for the standard text symbols
;

			INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
	PUBLIC	pointxy

	EXTERN	plot_decode_83

;
;	$Id: pointxy_83.asm $
;

; ******************************************************************
;
; Get pixel at (x,y) coordinate.
;
;
;
.pointxy

			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range

			push	bc
			push	de
			push	hl

			call plot_decode_83
			
			jr  c,odd
			and 1
			jr  even
.odd
			and 2
.even
			pop	hl
			pop	de
			pop	bc
			ret
