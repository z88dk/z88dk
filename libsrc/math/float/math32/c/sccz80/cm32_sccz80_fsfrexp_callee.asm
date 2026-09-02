
SECTION code_fp_math32

PUBLIC cm32_sccz80_frexp_callee

EXTERN m32_fsfrexp_callee

; float frexpf(float x, int16_t *pw2);
; sccz80: SP = ret, ptr, x.HL, x.DE
; core:   SP = ret, x.HL, x.DE, ptr  (same as am9511 / Z80 math32)
;
; Reverse like cam32_sccz80_frexp_callee (ret in HL, not AF).
.cm32_sccz80_frexp_callee
    pop hl                          ; ret
    pop bc                          ; ptr
    pop de                          ; x.HL
IF __CPU_GBZ80__
    push de                         ; save x.HL
    ld d,h
    ld e,l                          ; DE = ret
    ld hl,sp+2                      ; &x.DE
    ld a,(hl)
    ld (hl),e
    ld e,a
    inc hl
    ld a,(hl)
    ld (hl),d
    ld h,a
    ld l,e                          ; HL = x.DE; (sp+2) = ret
    pop de                          ; DE = x.HL
ELSE
    ex (sp),hl                      ; HL = x.DE; (sp) = ret
ENDIF
    push bc                         ; ptr
    push hl                         ; x.DE
    push de                         ; x.HL
    call m32_fsfrexp_callee
    ret
