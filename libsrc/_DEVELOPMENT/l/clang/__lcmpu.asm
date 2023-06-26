

SECTION code_crt_clang

PUBLIC __lcmpu


__lcmpu:
    or a
    sbc hl,bc
    add hl,bc
    push de
    push bc
    push iy
    pop bc
    ex de,hl
    jr z,maybeEqual
    sbc hl,bc
    push af
    pop hl
    res 6,l
    push hl
    pop af
    db $21
maybeEqual:
    sbc hl,bc
    ex de,hl
    pop bc
    pop de
    ret
