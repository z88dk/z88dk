;
;       Kaypro II pseudo graphics routines
;	Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;	Video memory paging.
;
;
;	$Id: swapgfxbk_83.asm $
;

	        SECTION code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

                PUBLIC    swapgfxbk1
                PUBLIC    _swapgfxbk1



.swapgfxbk
._swapgfxbk
	in a,($1c)
	set 7,a   ; video page on
	out ($1c),a
	ret

.swapgfxbk1
._swapgfxbk1
	in a,($1c)
	res 7,a   ; video page off
	out ($1c),a
	ret

