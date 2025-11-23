
SECTION code_fp_math16

PUBLIC cm16_sdcc___uint2h_callee
PUBLIC cm16_sdcc___uint2h_fastcall

EXTERN asm_f24_u16
EXTERN asm_f16_f24

.cm16_sdcc___uint2h_callee
    pop bc      ;return
    pop hl      ;value
    push bc
.cm16_sdcc___uint2h_fastcall
    call asm_f24_u16
    jp asm_f16_f24

