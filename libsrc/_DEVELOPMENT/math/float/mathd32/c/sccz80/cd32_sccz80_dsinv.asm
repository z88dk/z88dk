
; float __fsinv (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sccz80_fsinv

EXTERN cd32_sccz80_dread, md32_fsinv, cd32_sccz80_dret

.cd32_sccz80_fsinv

    ; negate sccz80 floats
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(1/number)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sccz80_dread

    call md32_fsinv         ; enter stack = ret
                            ;        BCDE = d32_float
                            ; return BCDE = d32_float
   

    jp cd32_sccz80_dret     ; return DEHL = sccz80_float
