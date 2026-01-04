;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;       vz_smoothscroll_wrap_l(addr startlocation, int height)
;       Performs a by-1-pixel scroll to the left of height rows
;       With wrap-around.
;*****************************************************

; ----- void __FASTCALL__ vz_smoothscroll_wrap_l(void *addr, char byte)
    SECTION code_clib
    PUBLIC  vz_smoothscroll_wrap_l
    PUBLIC  _vz_smoothscroll_wrap_l
    EXTERN  vz_smoothscroll_wrap_l

vz_smoothscroll_wrap_l:
_vz_smoothscroll_wrap_l:

    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af

    jp asm_vz_smoothscroll_wrap_l