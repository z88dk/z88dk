SECTION code_clib
SECTION code_l

PUBLIC l_setix
EXTERN l_jpix_addr

l_setix:
    push af
    ld a,l
    ld (l_jpix_addr),a
    ld a,h
    ld (l_jpix_addr+1),a
    pop af
    ret
