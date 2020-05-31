
SECTION code_fp_math16

EXTERN  asm_f16_f24
EXTERN  asm_f24_u16
EXTERN  asm_u16_f24
EXTERN  asm_i16_f24
EXTERN  asm_f24_add_callee
EXTERN  asm_f24_f16

PUBLIC  asm_f16_floor

; half m16_floor( half ) __z88dk_fastcall;

; Entry: hl = floating point number
.asm_f16_floor
    call asm_f16_f24
    bit 7,e                     ;check sign
    push af                     ;Save sign flag
    call asm_f24_u16            ;Exits hl = unsigned integer
    pop af
    jr NZ,was_negative
    call asm_u16_f24
    jp asm_f24_f16

.was_negative
    call asm_i16_f24
    ; And subtract 1
    push de
    push hl
    ld de,07f80h
    ld hl,08000h
    call asm_f24_add_callee
    jp asm_f24_f16
