;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;       vz_setspritesize(int width, int height)
;*****************************************************

; ----- void __FASTCALL__ vz_setspritesize(void *addr, char byte)
    SECTION code_clib
    PUBLIC  vz_setspritesize
    PUBLIC  _vz_setspritesize
    EXTERN  vz_setspritesize_callee
    EXTERN  asm_vz_setspritesize

vz_setspritesize:
_vz_setspritesize:

    pop     af
    pop     bc
    pop     hl
    push    af

    jp      asm_vz_setspritesize
