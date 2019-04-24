
; float __fsneg (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_fsneg

EXTERN cd32_sccz80_dread, md32_fsneg, cd32_sccz80_dret

.cd32_sccz80_fsneg

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(-number)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sccz80_dread

    call md32_fsneg         ; enter stack = ret
                            ;        BCDE = d32_float
                            ; return BCDE = d32_float
   

    jp cd32_sccz80_dret     ; return DEHL = sccz80_float
