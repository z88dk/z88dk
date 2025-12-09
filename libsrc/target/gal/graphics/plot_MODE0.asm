
    SECTION code_clib

    PUBLIC  plot_MODE0
    EXTERN  fastdot_MODE0

plot_MODE0:
    ld      a, l
    cp      48
    ret     nc
    ld      a, h
    cp      64
    ret     nc

    LD      D, H       ; X (C passes it in L)
    LD      E, L       ; Y (C passes it in H)
    call    fastdot_MODE0
    bit     7,(hl)
    jr      nz,noset
    ld      (hl),0x80
noset:
    OR      (HL)
    or      0x80        ;force graphics
    LD      (HL),A
    EXX
    RET

