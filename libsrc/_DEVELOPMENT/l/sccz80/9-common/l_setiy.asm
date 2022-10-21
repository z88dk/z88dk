SECTION code_clib
SECTION code_l

PUBLIC l_setiy
EXTERN l_jpiy_addr

l_setiy:
    push af
    ld a,l
    ld (l_jpiy_addr),a
    ld a,h
    ld (l_jpiy_addr+1),a
    pop af
    ret
