

SECTION code_fp

PUBLIC l_fix16_sint2f
PUBLIC l_fix16_slong2f

; Convert an integer type to a fixed type
l_fix16_sint2f:
l_fix16_slong2f:
    ld      a,h
    and     128
    ld      h,a
    ld      a,l
    and     127
    or      h
    ld      h,a
    ld      l,0
    ret
