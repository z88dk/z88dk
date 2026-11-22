
    SECTION code_clib

    PUBLIC  res_MODE0
    EXTERN  fastdot_MODE0

res_MODE0:
    ld      a, l
    cp      48
    ret     nc
    ld      a, h
    cp      64
    ret     nc
    LD      D, H
    LD      E, L
    call    fastdot_MODE0
    cpl
    bit     7,(hl)
    jr      nz,noset
    ld      (hl),0x80
noset:
    and     (HL)
    LD      (HL),A
    EXX
    RET


