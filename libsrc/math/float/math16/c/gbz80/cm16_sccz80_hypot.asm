SECTION code_clib
SECTION code_fp_math16
PUBLIC cm16_sccz80_hypot
EXTERN cm16_sccz80_hypot_callee

.cm16_sccz80_hypot
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
    push de
    push hl
    call cm16_sccz80_hypot_callee
    pop bc
    pop bc
    ret
