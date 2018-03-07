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
			EXTERN	GFX_COUT

.w_respixel
.w_xorpixel
						push hl
						push de

						LD 	C,27
						CALL	GFX_COUT
						LD 	C,'9'			; 8/9 = plot/unplot mode
						CALL	GFX_COUT
						
						pop de
						pop hl
						call	w_plotpixel
						
						LD 	C,27
						CALL	GFX_COUT
						LD 	C,'8'			; 8/9 = plot/unplot mode
						JP	GFX_COUT
