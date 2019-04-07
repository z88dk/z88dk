
SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcciyp_d322d

.cd32_sdcciyp_d322d

    ; convert d32_float to sdcc_float
    ;
    ; enter : BCDE = d32_float
    ;
    ; exit  : DEHL = sdcc_float
    ;
    ; uses  : f, bc, de, hl

    ld l,c
    ld h,b

;   add hl,hl           ; put sign into Carry
;   dec h               ; adjust bias from 127 (IEEE) to 126 (sdcc)
;   rr h                ; return sign from Carry
;   rr l

    ex de,hl            ; HLDE = sdcc_float

    ret                 ; return DEHL = sdcc_float
