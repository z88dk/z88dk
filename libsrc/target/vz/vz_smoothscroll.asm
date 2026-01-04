;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;       vz_smoothscroll(addr startlocation, int height)
;       Performs a by-1-pixel scroll to the left of height rows
;       Without wrap-around.
;*****************************************************

; ----- void __FASTCALL__ vz_smoothscroll(void *addr, char byte)
    SECTION code_clib
    PUBLIC  vz_smoothscroll
    PUBLIC  _vz_smoothscroll
    EXTERN  vz_smoothscroll

vz_smoothscroll:
_vz_smoothscroll:

    pop     af
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    af

