
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
    LD      A, 0x80
    JP      fastdot_MODE0

