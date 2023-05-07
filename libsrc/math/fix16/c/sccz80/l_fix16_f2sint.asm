

SECTION code_fp

PUBLIC l_fix16_f2sint
PUBLIC l_fix16_f2slong

; Convert a fixed point to a number
l_fix16_f2slong:
    ld      de,0
    ld      a,h
    rlca
    jr      nc,l_fix16_f2sint
    dec     de
l_fix16_f2sint:
    ld      a,h
    ld      l,a
    rlca
    sbc     a,a
    ld  h,a
    ret