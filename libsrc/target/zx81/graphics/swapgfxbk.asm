;
;       ZX81 Graphics Functions - Small C+ stubs
;
;	ZX 81 version By Stefano Bodrato
;
;	$Id: __gfx_vram_page_in.asm,v 1.11 2017-01-02 22:58:00 aralbrec Exp $
;

    SECTION code_clib
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out

		;EXTERN	save81
		;EXTERN	restore81

__gfx_vram_page_in:
___gfx_vram_page_in:
	        ;jp	$2E7	;setfast
    ret
		;jp	save81
__gfx_vram_page_out:
___gfx_vram_page_out:

; NOTE:  IX now should be preserved, using IY for any kind of ROM call will require "IX"
;        to be saved, set to 16384 while the ROM is being engaged, and restored back on exit.

; This will become IY when swapped !
;    ld      ix, 16384

		;jp	$207
    ret
                ;jp	restore81
