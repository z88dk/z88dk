
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_setix
EXTERN l_ix_addr

l_setix:
    push af
    ld a,l
    ld (l_ix_addr),a
    ld a,h
    ld (l_ix_addr+1),a
    pop af
    ret
