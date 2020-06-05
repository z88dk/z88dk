
SECTION code_fp_math16

PUBLIC cm16_sdcc_readr
PUBLIC cm16_sdcc_read1

.cm16_sdcc_readr

    ; sdcc half primitive
    ; Read right sdcc half from the stack
    ;
    ; Convert from sdcc_half calling to f16 half.
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret1, ret0
    ;
    ; exit  : stack = sdcc_half right, sdcc_half left, ret1
    ;          DEHL = sdcc_half right
    ; 
    ; uses  : f, bc, de, hl

    ld hl,6                     ; stack sdcc_half right
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = sdcc_float
    ex de,hl
    ret                         ; HL = sdcc_float ; return HL = sdcc_half right

.cm16_sdcc_read1

    ; sdcc half primitive
    ; Read left / single sdcc half from the stack
    ;
    ; Convert from sdcc_half calling to f16 half.
    ;
    ; enter : stack = sdcc_half, ret1, ret0
    ;
    ; exit  : stack = sdcc_half, ret1
    ;          DEHL = sdcc_half
    ; 
    ; uses  : f, bc, de, hl

    ld hl,4                     ; stack sdcc_half
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = sdcc_float
    ex de,hl
    ret                         ; HL = sdcc_float

