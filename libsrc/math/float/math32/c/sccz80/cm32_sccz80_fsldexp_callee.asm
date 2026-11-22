
SECTION code_fp_math32

PUBLIC cm32_sccz80_ldexp_callee

EXTERN m32_fsldexp_callee

; float ldexpf(float x, int16_t pw2);
; sccz80: SP = ret, pw2, x.HL, x.DE
; core:   SP = ret, x.HL, x.DE, pw2  (same as am9511 / Z80 math32)
;
; Reverse like cam32_sccz80_ldexp_callee (ret in HL, not AF).
.cm32_sccz80_ldexp_callee
    pop hl                          ; ret
    pop bc                          ; pw2
    pop de                          ; x.HL
IF __CPU_GBZ80__
    push de
    ld d,h
    ld e,l
    ld hl,sp+2
    ld a,(hl)
    ld (hl),e
    ld e,a
    inc hl
    ld a,(hl)
    ld (hl),d
    ld h,a
    ld l,e
    pop de
ELSE
    ex (sp),hl                      ; HL = x.DE; (sp) = ret
ENDIF
    push bc                         ; pw2
    push hl                         ; x.DE
    push de                         ; x.HL
    call m32_fsldexp_callee
    ret
