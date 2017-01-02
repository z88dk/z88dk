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
;	$Id: swapgfxbk.asm,v 1.2 2017-01-02 21:51:24 aralbrec Exp $
;


		SECTION	code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1


.swapgfxbk
._swapgfxbk
		di
		ret

.swapgfxbk1
._swapgfxbk1
	di
;	ld a,128		; premium graphics on
;	out ($1c),a
		;ei
		ret

