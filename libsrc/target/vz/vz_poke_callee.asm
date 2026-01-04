;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley 
;
;*****************************************************

; ----- void __CALLEE__ vz_poke_callee(void *addr, char byte)

    SECTION code_clib
    PUBLIC  vz_poke_callee
    PUBLIC  _vz_poke_callee
    EXTERN  asm_vz_poke

vz_poke_callee:
_vz_poke_callee:

    pop     af
    pop     bc
    pop     hl
    push    af

   ;  c = byte
   ; hl = addr

asm_vz_poke:
    ld    a,c
    ld    (hl),a
    ret