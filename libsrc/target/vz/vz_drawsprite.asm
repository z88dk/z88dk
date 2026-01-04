;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;       vz_drawsprite(int x, int y, int number)
;       Draw sprite 'number' at x,y
;*****************************************************

; ----- void __FASTCALL__ vz_drawsprite(int x, int y, int number)
    SECTION code_clib
    PUBLIC  vz_drawsprite
    PUBLIC  _vz_drawsprite
    EXTERN  vz_drawsprite_callee
    EXTERN  asm_vz_drawsprite

vz_drawsprite:
_vz_drawsprite:

    pop     af
    pop     bc
    pop     de
    pop     hl
    push    af

    jp      asm_vz_drawsprite
