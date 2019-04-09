
SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dread2, cd32_sdcc_dread1

EXTERN cd32_sdcc_dload

.cd32_sdcc_dread2

    ; sdcc float primitive
    ; Read two sdcc floats from the stack
    ;
    ; Convert from sdcc_float format to d32_float.
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret1, ret0
    ;
    ; exit  : stack = sdcc_float right, sdcc_float left, ret1, d32_float left
    ;         BCDE = d32_float right
    ; 
    ; uses  : af, bc, de, hl

    ld hl,4                 ; stack sdcc_float left
    add hl,sp

    call cd32_sdcc_dload    ; return BCDE = d32_float left

    pop af                  ; ret0

    push bc                 ; stack d32_float left
    push de

    push af                 ; ret0

;   ld hl,12                ; stack sdcc_float right
;   add hl,sp
    inc hl                  ; stack sdcc_float right

    jp cd32_sdcc_dload      ; return BCDE = d32_float right


.cd32_sdcc_dread1

    ; sdcc float primitive
    ; Read one sdcc float from the stack
    ;
    ; Convert from sdcc_float format to d32_float.
    ;
    ; enter : stack = sdcc_float, ret1, ret0
    ;
    ; exit  : stack = sdcc_float, ret1
    ;         BCDE = d32_float
    ; 
    ; uses  : f, bc, de, hl

    ld hl,4                 ; stack sdcc_float
    add hl,sp

    jp cd32_sdcc_dload      ; return BCDE = d32_float
   

