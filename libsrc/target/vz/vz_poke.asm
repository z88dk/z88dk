;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;
;*****************************************************

; ----- void __FASTCALL__ vz_poke(void *addr, char byte)
    SECTION code_clib
    PUBLIC  vz_poke
    PUBLIC  _vz_poke
    EXTERN  vz_poke_callee
    EXTERN  asm_vz_poke

vz_poke:
_vz_poke:

    pop     af
    pop     bc
    pop     hl
    push    af

    jp      asm_vz_poke
