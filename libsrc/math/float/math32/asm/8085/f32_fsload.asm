;
; 8085: load float at HL into DEHL
;
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsload

.m32_fsload
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)
    ld hl,bc
    ret
