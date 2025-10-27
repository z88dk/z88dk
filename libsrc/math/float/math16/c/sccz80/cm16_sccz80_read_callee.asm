
SECTION code_fp_math16

PUBLIC cm16_sccz80_readl_callee
PUBLIC cm16_sccz80_read1_callee

.cm16_sccz80_readl_callee

    ; sccz80 half primitive
    ; Read right sccz80 half from the stack
    ;
    ; enter : stack = sccz80_half left, sccz80_half right, ret1, ret0
    ;
    ; exit  : sccz80_half right, ret1
    ;         HL = sccz80_half left
    ; 
    ; uses  : af, bc, de, hl
    
    pop af                      ; my return
    pop bc                      ; ret 1
    pop de                      ; sccz80_half right
    pop hl                      ; sccz80_half left
    push de                     ; sccz80_half right
    push bc                     ; ret 1
    push af                     ; my return
    ret

.cm16_sccz80_read1_callee
    ; sccz80 half primitive
    ; Read a single sccz80 half from the stack
    ;
    ; enter : stack = sccz80_half, ret1, ret0
    ;
    ; exit  : ret1
    ;         HL = sccz80_half 
    ;
    ; uses  : af, bc, de, hl
    pop af                      ; my return
    pop bc                      ; ret 1
    pop hl                      ; sccz80_half
    push bc
    push af
    ret

