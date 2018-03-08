;
;       Otrona Attachè graphics routines
;		console driven video HW access
;
;       Stefano Bodrato 2018
;
;
;       Unplot pixel at (x,y) coordinate.
;
;
;	$Id: w_respixl.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION code_clib
			PUBLIC	w_respixel
			
			EXTERN	w_plotpixel
			EXTERN	w_xorpixel
			
				EXTERN	setres
				EXTERN	swapgfxbk1

.w_respixel
.w_xorpixel
						push hl
						push de
						
						call setres

						pop de
						pop hl
						
						call	w_plotpixel
						
						jp	swapgfxbk1
