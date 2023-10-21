;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;
;       Page the graphics bank in/out - used by all gfx functions
;       Version for the TRS80 Model 4 (CP/M or TRS-DOS)
;
;       Stefano - 6/2023
;
;
;	$Id: m4_swapgfxbk.asm $
;


		SECTION	code_clib

		PUBLIC    swapgfxbk
		PUBLIC    _swapgfxbk

		PUBLIC	swapgfxbk1
		PUBLIC   _swapgfxbk1


.swapgfxbk
._swapgfxbk
	di
	push af
 	ld	a,$86           ; page in the video bank, TRS80 character set
 	out	($84),a
	pop af
	ret


.swapgfxbk1
._swapgfxbk1
	push af
 	ld	a,$87       ; page out the video bank, TRS80 character set
 	out	($84),a     ; optreg
	pop af
	ei
	ret


;--------------------------------------------------
	SECTION		code_crt_init
	EXTERN		base_graphics
	ld	hl,$f800
	ld	(base_graphics),hl

