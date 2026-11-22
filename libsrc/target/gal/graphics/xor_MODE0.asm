
    SECTION code_clib

    PUBLIC  xor_MODE0
    EXTERN  fastdot_MODE0

xor_MODE0:
    ld      a, l
    cp      48
    ret     nc
    ld      a, h
    cp      64
    ret     nc
    LD      D, H       ; X (in L)
    LD      E, L       ; Y (in H)
    CALL    fastdot_MODE0
    bit     7,(hl)
    jr      nz,noset
    ld      (hl),0x80
noset:
    xor      (HL)
    or      0x80        ;force graphics
    LD      (HL),A
    EXX
    RET