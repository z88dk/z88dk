

SECTION code_clib

PUBLIC fgetc_cons
PUBLIC _fgetc_cons


fgetc_cons:
_fgetc_cons:
    in      a,($fa)
    and     1
    jp      nz,fgetc_cons
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

