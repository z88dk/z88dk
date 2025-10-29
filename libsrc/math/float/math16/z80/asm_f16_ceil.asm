
SECTION code_fp_math16

EXTERN  asm_f24_f16
EXTERN  asm_f24_discardfraction
EXTERN  asm_f24_add_callee
EXTERN  asm_f16_f24

PUBLIC  asm_f16_ceil

; half f16_ceil( half ) __z88dk_fastcall;

; Entry: hl = floating point number
.asm_f16_ceil
    call asm_f24_f16
    call asm_f24_discardfraction
    bit 7,e                     ;check sign
    jp NZ,asm_f16_f24           ;was negative

.was_positive
    ; And add 1
    push de
    push hl
    ld de,07f00h
    ld hl,08000h
    call asm_f24_add_callee
    jp asm_f16_f24

