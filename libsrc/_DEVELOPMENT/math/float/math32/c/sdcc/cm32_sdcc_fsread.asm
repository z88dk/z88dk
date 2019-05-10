
SECTION code_clib
SECTION code_math

PUBLIC cm32_sdcc_fsreadr, cm32_sdcc_fsreadl

EXTERN cm32_sdcc_fsload

.cm32_sdcc_fsreadr

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

    jp cm32_sdcc_fsload         ; return DEHL = sdcc_float right


.cm32_sdcc_fsreadl

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

    jp cm32_sdcc_fsload         ; return DEHL = sdcc_float
