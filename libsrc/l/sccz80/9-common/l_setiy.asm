
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_setiy
EXTERN l_iy_addr

l_setiy:
    push af
    ld a,l
    ld (l_iy_addr),a
    ld a,h
    ld (l_iy_addr+1),a
    pop af
    ret
