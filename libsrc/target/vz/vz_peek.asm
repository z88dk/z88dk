;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;
;*****************************************************

; ----- int __FASTCALL__ vz_peek(void *addr)
    SECTION code_clib
    PUBLIC  vz_peek
    PUBLIC  _vz_peek

vz_peek:
_vz_peek:

    pop     af
    pop     hl
    push    af

    ld a,(hl)
    ld h,0
    ld l,a
    ret