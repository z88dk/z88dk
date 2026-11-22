
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_cm_de

.l_cm_de
    ld a,d
    or a
    ret P

    cpl
    ld d,a
    ld a,e
    cpl
    ld e,a
    inc de
    ret

