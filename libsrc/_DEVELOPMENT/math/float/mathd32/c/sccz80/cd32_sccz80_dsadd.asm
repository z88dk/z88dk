
; float __fsadd (float left, float right)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_dsadd

EXTERN cd32_sccz80_dread, md32_fsadd, cd32_sccz80_dret

.cd32_sccz80_dsadd

    ; add two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, ret
    ;          BCDE = sccz80_float right
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cd32_sccz80_dread

    exx
    call cd32_sccz80_dload
    exx

    call md32_fsadd         ; enter stack = d32_float left
                            ;        BCDE = d32_float right
                            ; return BCDE = d32_float
    pop af
    pop af

    jp cd32_sccz80_dret     ; return DEHL = sccz80_float

