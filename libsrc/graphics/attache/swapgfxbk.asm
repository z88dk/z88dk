;
;       Otrona Attachè graphics lib
;       Stefano Bodrato 2018
;
;
;	Video memory paging.
;
;
;	$Id: swapgfxbk.asm $
;


	        SECTION code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

                PUBLIC    swapgfxbk1
                PUBLIC    _swapgfxbk1

			EXTERN	GFX_COUT

.swapgfxbk
._swapgfxbk
				ret

.swapgfxbk1
._swapgfxbk1

				LD 	C,27
				CALL	GFX_COUT
				LD 	C,'8'			; 8/9 = plot/unplot mode
				JP	GFX_COUT

