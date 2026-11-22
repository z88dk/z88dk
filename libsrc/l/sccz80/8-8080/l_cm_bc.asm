
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_cm_bc

.l_cm_bc
    ld a,b
    or a
    ret P

    cpl
    ld b,a
    ld a,c
    cpl
    ld c,a
    inc bc
    ret

