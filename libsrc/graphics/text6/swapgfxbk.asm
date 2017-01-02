;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;       Written by Stefano Bodrato 19/12/2006
;
;
;	Dummy gfx paging for text mode.
;
;
;	$Id: swapgfxbk.asm,v 1.4 2017-01-02 22:57:59 aralbrec Exp $
;


	        SECTION code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

                PUBLIC    swapgfxbk1
                PUBLIC    _swapgfxbk1


.swapgfxbk
._swapgfxbk
.swapgfxbk1
._swapgfxbk1
                ret






