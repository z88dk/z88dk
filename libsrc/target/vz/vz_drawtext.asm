;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;       vz_drawtext(int x, int y, *addr str)
;       Draw text str at x,y in mode(1) graphics
;*****************************************************

; ----- void __FASTCALL__ vz_drawtext(int x, int y, *addr str)
    SECTION code_clib
    PUBLIC  vz_drawtext
    PUBLIC  _vz_drawtext
    EXTERN  vz_drawtext_callee
    EXTERN  asm_vz_drawtext

vz_drawtext:
_vz_drawtext:

    pop     af
    pop     bc
    pop     hl
    pop     de
    push    de
    push    hl
    push    bc
    push    af

    jp      asm_vz_drawtext
