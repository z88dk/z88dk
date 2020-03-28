
SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsload

.cm32_sdcc_fsload

    ; sdcc float primitive
    ; Load float pointed to by HL into DEHL
    ;
    ; enter : HL = float* (sdcc_float)
    ;
    ; exit  : DEHL = float (sdcc_float)
    ;
    ; uses  : bc, de, hl

    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DEBC = sdcc_float

    ld l,c
    ld h,b

    ret                         ; DEHL = sdcc_float
