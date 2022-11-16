
        SECTION code_clib

	PUBLIC	xorpixel
	EXTERN	__gfx_coords

	EXTERN		putvid_a
	EXTERN		getvid_a

	EXTERN		plotpixel
	EXTERN		respixel

;
;	$Id: xorpixl.asm $
;

; ******************************************************************
;
; XORs pixel at (x,y) coordinate.
;
; Gemini Galaxy version
; 160x75 dots.
;
.xorpixel
				ld	a,h
				cp	160
				ret	nc
				ld	a,l
				;cp	maxy
				cp	75
				ret	nc		; y0	out of range
				
				ld  a,27
				call putvid_a
				ld  a,'T'
				call putvid_a
				ld  a,h
				add 32
				call putvid_a
				ld  a,l
				add 32
				call putvid_a
				
				call getvid_a
				cp  2	; illegal coordinates ?
				ret z

				and a	; ON/OFF status
				
				jp z, plotpixel
				jp respixel
