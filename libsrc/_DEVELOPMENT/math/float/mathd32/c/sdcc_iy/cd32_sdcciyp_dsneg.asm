
; float __fsneg (float a1)

SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcciyp_dsneg

EXTERN cd32_sdcciyp_dread1, md32_neg, cd32_sdcciyp_d322d

.cd32_sdcciyp_dsneg

    ; negate sdcc floats
    ;
    ; enter : stack = sdcc_float a1, ret
    ;
    ; exit  : DEHL = sdcc_float(-a1)
    ;
    ; uses  : af, bc, de, hl

    call cd32_sdcciyp_dread1

;   call md32_neg           ; enter stack = sdcc_float, ret
                            ;        BCDE = d32_float
                            ; return BCDE = d32_float
   

    jp cd32_sdcciyp_d322d   ; return DEHL = sdcc_float
