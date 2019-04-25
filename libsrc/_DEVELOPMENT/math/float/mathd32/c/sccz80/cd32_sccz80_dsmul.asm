
; float __fsmul (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsmul

EXTERN cd32_sccz80_dread, cd32_sccz80_dload, md32_fsmul, cd32_sccz80_dret

.cd32_sccz80_dsmul

    ; multiply two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, ret
    ;          DEHL = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sccz80_dread

    exx
    call cd32_sccz80_dload
    exx

    call md32_fsmul         ; enter stack = d32_float left
                            ;        BCDE = d32_float right
                            ; return BCDE = d32_float
    pop af
    pop af

    jp cd32_sccz80_dret     ; return DEHL = sccz80_float

