;
;    OZ-7xx DK emulation layer for Z88DK
;    by Stefano Bodrato - Oct. 2003
;
;    int icos(unsigned degrees) __z88dk_fastcall;
;    input must be between 0 and 360
;


    SECTION code_clib
    PUBLIC  icos
    PUBLIC  _icos

    EXTERN  isin

icos:
_icos:
    ; __FASTCALL__
    ld      b,h
    ld      c,l

    ld      hl,90
    or      a
    sbc     hl,bc
    jp      nc,isin
    ld      bc,360
    add     hl,bc
    jp      isin

