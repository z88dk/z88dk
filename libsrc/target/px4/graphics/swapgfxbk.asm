;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk.asm,v 1.4 2017-01-02 22:57:59 aralbrec Exp $
;

		SECTION	code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1



.swapgfxbk
._swapgfxbk
.swapgfxbk1
._swapgfxbk1
                ret






