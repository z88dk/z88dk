
SECTION code_fp_math16

PUBLIC cm16_sccz80_readl
PUBLIC cm16_sccz80_read1

.cm16_sccz80_readl

    ; sccz80 half primitive
    ; Read right sccz80 half from the stack
    ;
    ; enter : stack = sccz80_half left, sccz80_half right, ret1, ret0
    ;
    ; exit  : stack = sccz80_half left, sccz80_half right, ret1
    ;          DEHL = sccz80_half right
    ; 
    ; uses  : f, de, hl

    ld hl,6                     ; stack sccz80_half left
    add hl,sp

    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = sccz80_half
    ex de,hl
    ret                         ; return HL = sccz80_half left


.cm16_sccz80_read1

    ; sccz80 half primitive
    ; Read left / single sccz80 half from the stack
    ;
    ; enter : stack = sccz80_half, ret1, ret0
    ;
    ; exit  : stack = sccz80_half, ret1
    ;          DEHL = sccz80_half
    ; 
    ; uses  : f, de, hl

    ld hl,4                     ; stack sccz80_half
    add hl,sp

    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = sccz80_half
    ex de,hl
    ret                         ; return HL = sccz80_half

