;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Color HRG version by Stefano Bodrato
;
;	$Id: cplot_callee.asm $
;

;Usage: cplot_callee(int x, int y, int color)


        SECTION code_clib
        PUBLIC  cplot_callee
        PUBLIC  _cplot_callee
        EXTERN  __gfx_page_vram_in
        EXTERN  __gfx_page_vram_out

        EXTERN  cplotpixel

cplot_callee:
_cplot_callee:
        pop     af
        pop     bc
        pop     de
        pop     hl
        push    af
        ld      a, c
        ex      af, af

        call    __gfx_page_vram_in
        call    cplotpixel
        jp      __gfx_page_vram_out

