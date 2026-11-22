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
;	$Id: __gfx_vram_page_in.asm,v 1.8 2017-01-02 22:57:59 aralbrec Exp $
;

    SECTION code_clib
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in

    EXTERN  __z88_gfxbank
    EXTERN  z88_map_bank

    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out


    INCLUDE "classic/gfx/grafix.inc"

__gfx_vram_page_in:
___gfx_vram_page_in:
__gfx_vram_page_out:
___gfx_vram_page_out:
    push    hl
    push    de
    ld      hl, z88_map_bank            ;$4Dx
    ld      e, (hl)
    ld      a, (__z88_gfxbank)               ;in crt0
    ld      (hl), a
    out     (z88_map_bank-$400), a
    ld      a, e
    ld      (__z88_gfxbank), a
    pop     de
    pop     hl
    ret






