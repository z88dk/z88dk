;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;       vz_coursescroll(addr startlocation, int height)
;       Performs a by-1-pixel scroll to the left of height rows
;       Without wrap-around.
;*****************************************************

; ----- void __FASTCALL__ vz_smoothscroll(void *addr, char byte)
    SECTION code_clib
    PUBLIC  vz_coursescroll
    PUBLIC  _vz_coursescroll
    EXTERN  vz_coursescroll

vz_coursescroll:
_vz_coursescroll:

    pop     af
    pop     bc
    pop     hl
    push    af

