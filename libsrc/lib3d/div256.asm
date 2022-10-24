;
;    OZ-7xx DK emulation layer for Z88DK
;    by Stefano Bodrato - Oct. 2003
;
;    int div256(long value) __z88dk_fastcall;
;    divide by 256
;

    SECTION code_clib
    PUBLIC  div256
    PUBLIC  _div256

div256:
_div256:
    ;pop     bc
    ;pop     hl
    ;pop     de
    ;push    de
    ;push    hl
    ;push    bc

    ; DEHL holds value

    ld      l,h
    ld      h,e

    ret
