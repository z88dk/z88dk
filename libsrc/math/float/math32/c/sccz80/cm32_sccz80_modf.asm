
SECTION code_fp_math32

PUBLIC cm32_sccz80_modf

EXTERN _m32_modff

; float modff(float x, float *y) non-callee (caller drops args)
; sccz80 entry: SP = ret, y(2), x(4)
; 8080/8085/gbz80 _m32_modff is already that layout.
; Z80 SDCC _m32_modff wants SP = ret, x(4), y(2).

IF __CPU_INTEL__ | __CPU_GBZ80__

.cm32_sccz80_modf
    jp _m32_modff

ELSE

.cm32_sccz80_modf
    pop af                      ; ret
    pop bc                      ; y
    pop hl                      ; x LSW
    pop de                      ; x MSW
    push bc                     ; y (deep)
    push de                     ; x MSW
    push hl                     ; x LSW
    push af                     ; ret
    jp _m32_modff

ENDIF
