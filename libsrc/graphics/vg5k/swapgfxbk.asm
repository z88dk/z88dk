;
;       Philips VG-5000 Graphics Functions
;
;       swapgfxbk ()  -- foo routine for fake swapping
;
;       Stefano Bodrato - 2015
;
;
;	$Id: swapgfxbk.asm,v 1.2 2016-06-16 19:38:12 dom Exp $
;

	        SECTION code_clib
		PUBLIC	swapgfxbk

		PUBLIC	swapgfxbk1



.swapgfxbk
		ld	ix,$47FA
		ret
.swapgfxbk1
		ret






