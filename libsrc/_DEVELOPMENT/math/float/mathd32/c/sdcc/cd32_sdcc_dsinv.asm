
; float __fsinv (float number)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_fsinv

EXTERN cd32_sdcc_dread1, md32_fsinv, cd32_sdcc_dret

.cd32_sdcc_fsinv

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float number, ret
    ;
    ; exit  : DEHL = sdcc_float(-number)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sdcc_dread1

    call md32_fsinv         ; enter stack = sdcc_float, ret
                            ;        BCDE = d32_float
                            ; return BCDE = d32_float
   

    jp cd32_sdcc_dret       ; return DEHL = sdcc_float
