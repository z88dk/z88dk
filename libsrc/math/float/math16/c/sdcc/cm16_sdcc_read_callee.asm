
SECTION code_fp_math16

PUBLIC cm16_sdcc_readr_callee
PUBLIC cm16_sdcc_read1_callee

.cm16_sdcc_readr_callee

    ; sdcc half_t primitive
    ; Read right sdcc half_t from the stack
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret1, ret0
    ;
    ; exit  : sdcc_half left, ret1
    ;         HL = sdcc_half right
    ; 
    ; uses  : af, bc, de, hl

    pop af                      ; my return
    pop bc                      ; ret 1
    pop de                      ; sdcc_half left
    pop hl                      ; sdcc_half right
    push de                     ; sdcc_half left 
    push bc                     ; ret 1
    push af                     ; my return
    ret

.cm16_sdcc_read1_callee
    ; sdcc half_t primitive
    ; Read a single sdcc half_t from the stack
    ;
    ; enter : stack = sdcc_half, ret1, ret0
    ;
    ; exit  : ret1
    ;         HL = sdcc_half 
    ;
    ; uses  : af, bc, de, hl
    pop af                      ; my return
    pop bc                      ; ret 1
    pop hl                      ; sdcc_half
    push bc
    push af
    ret

