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
;	$Id: __gfx_page_vram_in.asm $
;


    SECTION code_clib

    PUBLIC  __gfx_page_vram_in
    PUBLIC  ___gfx_page_vram_in

    PUBLIC  __gfx_page_vram_out
    PUBLIC  ___gfx_page_vram_out


__gfx_page_vram_in:
___gfx_page_vram_in:

 ;   di
    ret



__gfx_page_vram_out:
___gfx_page_vram_out:
extern __bdos

    ld      e,6         ; Home cursor
    ld      c,2
    call    __bdos
    ld      e,32
    ld      c,2
    call    __bdos
    ld      e,32
    ld      c,2
    call    __bdos

    ld      e,148       ; Force graphics character set
    ld      c,2
    jp     __bdos

