

SECTION code_fp

PUBLIC l_fix16_f2uint
PUBLIC l_fix16_f2ulong

; Convert a fixed point to a number
l_fix16_f2ulong:
    ld      de,0
l_fix16_f2uint:
    ld      a,h
    and     127
    ld      l,a
    ld      h,0
    ret