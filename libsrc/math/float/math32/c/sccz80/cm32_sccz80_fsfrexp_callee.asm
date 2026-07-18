
SECTION code_fp_math32

PUBLIC cm32_sccz80_frexp_callee

EXTERN m32_fsfrexp_callee

; float frexpf(float x, int16_t *pw2);
; sccz80: push x; push ptr; call → SP = ret, ptr, x.HL, x.DE
; m32_fsfrexp_callee: SP = ret, x.HL, x.DE, ptr
.cm32_sccz80_frexp_callee
    pop bc                          ; BC = ret
    pop hl                          ; HL = ptr
    pop de                          ; DE = x.HL
    ex (sp),hl                      ; HL = x.DE; (sp) = ptr
    push de                         ; x.HL
    push hl                         ; x.DE : SP = x.DE, x.HL, ptr
    ; reorder to x.HL, x.DE, ptr then push ret
    pop hl                          ; x.DE
    pop de                          ; x.HL
    ; SP = ptr; DE = x.HL; HL = x.DE; BC = ret
    push de                         ; x.HL
    push hl                         ; x.DE : SP = x.DE, x.HL, ptr
    ; still wrong order (x.DE on top). m32 pops x.HL then x.DE so top should be x.HL
    pop hl                          ; x.DE
    pop de                          ; x.HL
    ; SP = ptr; DE=x.HL; HL=x.DE
    push hl                         ; x.DE
    push de                         ; x.HL : SP = x.HL, x.DE, ptr  ✓ for m32 after ret
    push bc                         ; ret : SP = ret, x.HL, x.DE, ptr  ✓
    jp m32_fsfrexp_callee
