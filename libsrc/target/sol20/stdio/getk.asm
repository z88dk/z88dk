

SECTION code_clib

PUBLIC getk
PUBLIC _getk


getk:
_getk:
    ld      hl,0
    in      a,($FA)
    and     1
    ret     nz
    in      a,($fc)
    ld      l,a
    ld      h,0
    cp      10
    jp      nz,not_lf
    ld      l,13
not_lf:
    cp      13
    ret     nz
    ld      l,10
    ret
    
