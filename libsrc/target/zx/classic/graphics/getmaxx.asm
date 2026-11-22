    MODULE  getmaxx
    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __zx_gfxmode
    EXTERN  __console_w
    EXTERN  __gfx_fatpix

getmaxx:
_getmaxx:
    ld      a, (__zx_gfxmode)
    ld      hl, 255
    cp      3
    ret     c
    and     7
    cp      6
    jr      nz, zxn_getmaxx
    ld      a, (__gfx_fatpix)
    and     a
    ret     nz
    ld      hl, 511
    ret
zxn_getmaxx:
    ld      a, (__zx_gfxmode)
    bit     7,a     ;Layer2
    ret     nz
	; So we must be left with a ZXN screenmode
    ld      hl, (__console_w)
    ld      h, 0
    add     hl, hl
    dec     hl
    ret
