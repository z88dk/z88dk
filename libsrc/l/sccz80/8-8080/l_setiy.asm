
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_setiy
EXTERN l_iy_addr

l_setiy:
    ld (l_iy_addr),hl
    ret
