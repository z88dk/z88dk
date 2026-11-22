;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Color HRG version by Stefano Bodrato
;
;	$Id: cplot.asm $
;

;Usage: cplot(int x, int y, int color)


        SECTION code_clib

        PUBLIC  cplot
        PUBLIC  _cplot
        EXTERN  __gfx_vram_page_in
        EXTERN  __gfx_vram_page_out

        EXTERN  cplotpixel

cplot:
_cplot:
        pop     af
        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc
        push    af
        ld      a, c
        ex      af, af

        call    __gfx_vram_page_in
        call    cplotpixel
        jp      __gfx_vram_page_out

