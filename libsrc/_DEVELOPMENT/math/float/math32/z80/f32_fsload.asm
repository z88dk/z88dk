

SECTION code_fp_math32

PUBLIC m32_fsload

.m32_fsload

    ; 32 bit float primitive
    ; Load float pointed to by HL into DEHL
    ;
    ; enter : HL = float*
    ;
    ; exit  : DEHL = float
    ;
    ; uses  : f, bc, de, hl

    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)                   ; DEBC = float

    ld hl,bc

    ret                         ; DEHL = float
