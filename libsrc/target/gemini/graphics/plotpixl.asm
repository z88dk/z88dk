
        SECTION code_clib

	PUBLIC	plotpixel
	EXTERN		putvid_a

	EXTERN	__gfx_coords

;
;	$Id: plotpixl.asm $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
;
; Gemini Galaxy version
; 160x75 dots.
;
;
.plotpixel
				ld	a,h
				cp	160
				ret	nc
				ld	a,l
				;cp	maxy
				cp	75
				ret	nc		; y0	out of range
				
				ld	(__gfx_coords),hl

				ld  a,27
				call putvid_a
				ld  a,'S'
				call putvid_a
				ld  a,h
				add 32
				call putvid_a
				ld  a,l
				add 32
				jp putvid_a
