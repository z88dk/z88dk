SECTION code_clib
SECTION code_l

PUBLIC l_setiy
EXTERN l_jpiy_addr

l_setiy:
    ld (l_jpiy_addr),hl
    ret
