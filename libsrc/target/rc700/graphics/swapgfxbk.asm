;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;
;       Page the graphics bank in/out - used by all gfx functions
;       Version for the TRS80 Model II CP/M
;
;       Stefano Bodrato - 2025
;
;
;	$Id: __gfx_vram_page_in.asm $
;


    SECTION code_clib

    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out
    EXTERN  RC700_DISPLAY

__gfx_vram_page_in:
___gfx_vram_page_in:

 ;   di
    ret



__gfx_vram_page_out:
___gfx_vram_page_out:
    ld      a, 132      ;Force graphics mode
    ld      (RC700_DISPLAY),a
    ret
