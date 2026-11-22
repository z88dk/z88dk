; Paging for address spaces for the Spectrum 128
;
; We've named address spaces after the banks for clarity

SECTION code_user

PUBLIC _setb1, _setb4
EXTERN l_push_di, l_pop_ei


_setb4:
    ld    a,4
    jr    page

_setb1:
    ld    a,1
page:
    di
    or    16
    ld    bc,32765
    out   (c),a
    ld    (23388),a
    ei
    ret

