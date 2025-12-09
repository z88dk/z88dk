
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
    push    de
    XOR     A         ; mode 0 for ifdot
    CALL    fastdot_MODE0
    pop     de
    ld      a,0x80        ;plot
    jp      z,fastdot_MODE0
    ld      a,1           ;unplot
    jp      fastdot_MODE0
