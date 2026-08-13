SECTION code_clib
SECTION code_fp_math16
PUBLIC cm16_sccz80_add
EXTERN asm_f16_add_callee

; enter stack: left, right, ret
; callee wants: right in HL, stack left, ret
.cm16_sccz80_add
    pop bc                      ; ret
    pop hl                      ; right
    ; stack: left
    push bc                     ; ret
    jp asm_f16_add_callee
