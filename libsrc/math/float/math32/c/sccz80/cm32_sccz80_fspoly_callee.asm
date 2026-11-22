SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fspoly_callee
EXTERN m32_fspoly_callee

; For CPUs with exx this reorders; for 8085 m32_polyf is called as
; _m32_polyf directly. If poly() library entry is used on 8085:
; sccz80 SP = ret, n, dptr, x — same as m32_fspoly_callee now.
IF __CPU_INTEL__ | __CPU_GBZ80__
defc cm32_sccz80_fspoly_callee = m32_fspoly_callee
ELSE

.cm32_sccz80_fspoly_callee
    pop af
    pop hl
    pop de
    exx
    pop hl
    pop de
    exx
    push hl
    push de
    exx
    push de
    push hl
    push af
    jp m32_fspoly_callee

ENDIF
