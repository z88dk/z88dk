
; half __div (half left, half right) — restoring div
; sccz80 non-callee: leave left+right on stack (same protocol as mul).

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_div

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_div_f24

.cm16_sccz80_div
    ; enter : stack = left, right, ret  (right under ret)
    ; exit  : HL = left/right; left+right remain for caller pops
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop bc                      ; ret
    pop hl                      ; right (y)
    exx

    pop hl                      ; left (x)
    push hl                     ; leave left for caller
    call asm_f24_f16            ; expand x → main
    exx                         ; main = y half, alt = x f24

    push hl                     ; leave right for caller
    push bc                     ; ret
    call asm_f24_f16            ; expand y → main
    exx                         ; main = x f24, alt = y f24
    call asm_f24_div_f24
    jp asm_f16_f24
