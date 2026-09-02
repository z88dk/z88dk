
SECTION code_fp_math32

PUBLIC cm32_sccz80_frexp

EXTERN m32_fsfrexp_callee

; float frexpf(float x, int16_t *pw2) non-callee
; sccz80: SP = ret, ptr, x.HL, x.DE — caller cleans 6 bytes
.cm32_sccz80_frexp
    pop hl                          ; ret
    pop bc                          ; ptr
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
    push bc                         ; ptr
    push hl                         ; x.DE
    push de                         ; x.HL
    call m32_fsfrexp_callee

    pop bc                          ; ret
    push bc
    push bc
    push bc
    push bc                         ; ret + 3 dummy words (6 bytes args)
    ret
