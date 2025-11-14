
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_setix
EXTERN l_ix_addr

l_setix:
    ld (l_ix_addr),hl
    ret
