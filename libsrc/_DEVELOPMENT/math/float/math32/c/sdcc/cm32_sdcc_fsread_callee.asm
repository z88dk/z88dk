
SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sdcc_fsreadr_callee
PUBLIC cm32_sdcc_fsread1_callee

.cm32_sdcc_fsreadr_callee

    ; sdcc float primitive
    ; Read right sdcc float from the stack
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

.cm32_sdcc_fsread1_callee
    ; sdcc float primitive
    ; Read a single sdcc float from the stack
    ;
    ; enter : stack = sdcc_float, ret1, ret0
    ;
    ; exit  : ret1
    ;         DEHL = sdcc_float 
    ;
    ; uses  : af, bc, de, hl
    pop af                      ; my return
    pop bc                      ; ret 1
    pop hl                      ; sdcc_float
    pop de
    push bc
    push af
    ret
