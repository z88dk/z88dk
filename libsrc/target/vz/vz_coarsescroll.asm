;*****************************************************
;
;   Video Technology library for small C compiler
;
;       Jason Oakley
;       vz_coarsescroll(addr startlocation, int height)
;       Performs a by-1-pixel scroll to the left of height rows
;       Without wrap-around.
;*****************************************************

; ----- void __FASTCALL__ vz_coarsescroll(void *addr, char byte)
    SECTION code_clib
    PUBLIC  vz_coarsescroll
    PUBLIC  _vz_coarsescroll
    EXTERN  vz_coarsescroll

vz_coarsescroll:
_vz_coarsescroll:

    pop     af
    pop     bc
    pop     hl
    push    af

