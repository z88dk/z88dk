
SECTION code_clib
PUBLIC fgetc_cons
PUBLIC _fgetc_cons


fgetc_cons:
_fgetc_cons:
    xor     a
    defb    $49		;LIS
    rst     $08
    and    a
    jr     z,fgetc_cons
    ld     l,a
    ld     h,0
    cp     13
    ret    nz
    ld     l,10
    ret
