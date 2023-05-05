

SECTION code_clib

PUBLIC l_fix16_uint2f
PUBLIC l_fix16_ulong2f


l_fix16_uint2f:
l_fix16_ulong2f:
    ld      a,l
    and     127
    ld      h,a
    ld      l,0
    ret
