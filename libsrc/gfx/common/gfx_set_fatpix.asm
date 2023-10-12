
        SECTION code_clib
        PUBLIC  gfx_set_fatpix
        PUBLIC  _gfx_set_fatpix
        PUBLIC  ___gfx_set_fatpix
        EXTERN  __gfx_fatpix

; void gfx_set_fatpix(int enable);
gfx_set_fatpix:
_gfx_set_fatpix:
___gfx_set_fatpix:
        pop     bc
        pop     hl
        push    hl
        push    bc
        ld      a, l
        ld      (__gfx_fatpix), a
        ret
