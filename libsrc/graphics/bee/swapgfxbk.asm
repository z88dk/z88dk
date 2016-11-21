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
;	$Id: swapgfxbk.asm,v 1.1 2016-11-21 11:18:38 stefano Exp $
;


		SECTION	code_clib
                PUBLIC    swapgfxbk

		PUBLIC	swapgfxbk1


.swapgfxbk
		di
		ret

.swapgfxbk1
	di
;	ld a,128		; premium graphics on
;	out ($1c),a
		;ei
		ret

