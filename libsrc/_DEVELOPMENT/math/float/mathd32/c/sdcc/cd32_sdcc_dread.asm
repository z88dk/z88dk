
SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dreadr, cd32_sdcc_dreadl

EXTERN cd32_sdcc_dload

.cd32_sdcc_dreadr

    ; sdcc float primitive
    ; Read right sdcc float from the stack
    ;
    ; Convert from sdcc_float calling to d32_float.
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret1, ret0
    ;
    ; exit  : stack = sdcc_float right, sdcc_float left, ret1
    ;          DEHL = sdcc_float right
    ; 
    ; uses  : af, bc, de, hl

    ld hl,8                     ; stack sdcc_float right
    add hl,sp

    jp cd32_sdcc_dload          ; return DEHL = sdcc_float right


.cd32_sdcc_dreadl

    ; sdcc float primitive
    ; Read left / single sdcc float from the stack
    ;
    ; Convert from sdcc_float calling to d32_float.
    ;
    ; enter : stack = sdcc_float, ret1, ret0
    ;
    ; exit  : stack = sdcc_float, ret1
    ;          DEHL = sdcc_float
    ; 
    ; uses  : f, bc, de, hl

    ld hl,4                     ; stack sdcc_float
    add hl,sp

    jp cd32_sdcc_dload          ; return DEHL = sdcc_float
