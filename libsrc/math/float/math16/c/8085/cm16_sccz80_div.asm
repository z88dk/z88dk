
; half __div (half left, half right) — restoring div, 8085
; Same non-callee trampoline as cm16_sccz80_add / mul.

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_div

EXTERN asm_f16_div_callee

; enter stack: left, right, ret
; callee wants: right in HL, stack left, ret
.cm16_sccz80_div
    pop bc                      ; ret
    pop hl                      ; right (y)
    ; stack: left
    push bc                     ; ret
    jp asm_f16_div_callee
