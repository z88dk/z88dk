;
;       ZX81 Graphics Functions - Small C+ stubs
;
;	ZX 81 version By Stefano Bodrato
;
;	$Id: swapgfxbk.asm,v 1.11 2017-01-02 22:58:00 aralbrec Exp $
;

    SECTION code_clib
    PUBLIC  swapgfxbk
    PUBLIC  _swapgfxbk

    PUBLIC  swapgfxbk1
    PUBLIC  _swapgfxbk1

		;EXTERN	save81
		;EXTERN	restore81

swapgfxbk:
_swapgfxbk:
	        ;jp	$2E7	;setfast
    ret
		;jp	save81
swapgfxbk1:
_swapgfxbk1:

; NOTE:  IX now should be preserved, using IY for any kind of ROM call will require "IX"
;        to be saved, set to 16384 while the ROM is being engaged, and restored back on exit.

; This will become IY when swapped !
;    ld      ix, 16384

		;jp	$207
    ret
                ;jp	restore81
