
SECTION code_fp_math32

PUBLIC cm32_sccz80_ldexp

EXTERN m32_fsldexp_callee

; float ldexpf(float x, int16_t pw2) non-callee
; sccz80: SP = ret, pw2, x.HL, x.DE — caller cleans 6 bytes
.cm32_sccz80_ldexp
    pop hl                          ; ret
    pop bc                          ; pw2
    pop de                          ; x.HL
    ex (sp),hl                      ; HL = x.DE; (sp) = ret
    push bc                         ; pw2
    push hl                         ; x.DE
    push de                         ; x.HL
    call m32_fsldexp_callee

    pop bc                          ; ret
    push bc
    push bc
    push bc
    push bc                         ; ret + 3 dummy words (6 bytes args)
    ret
