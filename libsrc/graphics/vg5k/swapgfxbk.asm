;
;       Philips VG-5000 Graphics Functions
;
;       swapgfxbk ()  -- foo routine for fake swapping
;
;       Stefano Bodrato - 2015
;
;
;	$Id: swapgfxbk.asm,v 1.3 2017-01-02 22:57:59 aralbrec Exp $
;

	        SECTION code_clib
		PUBLIC	swapgfxbk
      PUBLIC   _swapgfxbk

		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1



.swapgfxbk
._swapgfxbk
		ld	ix,$47FA
		ret
.swapgfxbk1
._swapgfxbk1
		ret






