
    SECTION code_clib

    PUBLIC  pointxy_MODE0
    EXTERN  fastdot_MODE0

pointxy_MODE0:
    ld      a, l
    cp      48
    ret     nc
    ld      a, h
    cp      64
    ret     nc
    LD      D, H       ; X (in L)
    LD      E, L       ; Y (in H)
    XOR     A         ; mode 0 for ifdot
    CALL    fastdot_MODE0
    ; result of AND (HL) was done in fastdot; we now use Z flag
    LD      HL, 0          ; Return z flag.Place result in L for return
    RET     Z         ; if Zero (pixel is OFF), return 0
    LD      L, 1       ; else ON
    RET