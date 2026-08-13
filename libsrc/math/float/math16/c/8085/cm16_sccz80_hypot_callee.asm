;
;  8085 hypot callee — stack only, no exx
;

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_hypot_callee

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_mul_f24
EXTERN asm_f24_add_f24
EXTERN asm_f24_sqrt

.cm16_sccz80_hypot_callee
    ; stack: left, right, ret
    pop bc                      ; ret
    pop hl                      ; right
    pop de                      ; left
    push bc                     ; ret
    push de                     ; left

    call asm_f24_f16            ; right → f24
    push de
    push hl                     ; right f24 as X for mul with itself
    call asm_f24_mul_f24        ; right^2 (Y=right, X=right)
    push de
    push hl                     ; save right^2

    ; stack: right^2.hl, right^2.de, left, ret
    ld de,sp+4
    ld hl,(de)                  ; HL = left half
    call asm_f24_f16
    push de
    push hl
    call asm_f24_mul_f24        ; left^2
    ; stack: right^2.hl, right^2.de, left, ret
    call asm_f24_add_f24        ; left^2 + right^2 (right^2 on stack)
    call asm_f24_sqrt
    pop bc                      ; drop left leftover
    jp asm_f16_f24
