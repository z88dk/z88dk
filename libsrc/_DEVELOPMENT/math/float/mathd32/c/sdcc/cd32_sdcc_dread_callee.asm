
SECTION code_clib
SECTION code_math

PUBLIC cd32_sdcc_dreadr_callee

.cd32_sdcc_dreadr_callee

    ; sdcc float primitive
    ; Read right sdcc float from the stack
    ;
    ; Convert from sdcc_float calling to d32_float.
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret1, ret0
    ;
    ; exit  : sdcc_float left, ret1
    ;         DEHL = sdcc_float right
    ; 
    ; uses  : af, bc, de, hl, bc', de', hl'
    
    pop af                      ; my return
    pop bc                      ; ret 1
    exx
    pop hl                      ; sdcc_float left
    pop de
    exx
    pop hl                      ; sdcc_float right
    pop de
    exx
    push de                     ; sdcc_float left
    push hl
    exx                         ; sdcc_float right   
    push bc                     ; ret 1
    push af                     ; my return
    ret

