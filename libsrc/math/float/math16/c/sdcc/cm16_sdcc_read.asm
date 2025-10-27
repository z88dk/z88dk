
SECTION code_fp_math16

PUBLIC cm16_sdcc_readr
PUBLIC cm16_sdcc_read1
PUBLIC cm32_sdcc_read1

.cm16_sdcc_readr

    ; sdcc half_t primitive
    ; Read right sdcc half_t from the stack
    ;
    ; Convert from sdcc_half calling to f16 half_t.
    ;
    ; enter : stack = sdcc_half right, sdcc_half left, ret1, ret0
    ;
    ; exit  : stack = sdcc_half right, sdcc_half left, ret1
    ;          DEHL = sdcc_half right
    ; 
    ; uses  : f, de, hl

    ld hl,6                     ; stack sdcc_half right
    add hl,sp

    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = sdcc_float
    ex de,hl
    ret                         ; HL = sdcc_float ; return HL = sdcc_half right

.cm16_sdcc_read1

    ; sdcc half_t primitive
    ; Read left / single sdcc half_t from the stack
    ;
    ; Convert from sdcc_half calling to f16 half_t.
    ;
    ; enter : stack = sdcc_half, ret1, ret0
    ;
    ; exit  : stack = sdcc_half, ret1
    ;          DEHL = sdcc_half
    ; 
    ; uses  : f, de, hl

    ld hl,4                     ; stack sdcc_half
    add hl,sp

    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DE = sdcc_float
    ex de,hl
    ret                         ; HL = sdcc_float

.cm32_sdcc_read1

    ; sdcc float primitive
    ; Read left / single sdcc float from the stack
    ;
    ; enter : stack = sdcc_float, ret1, ret0
    ;
    ; exit  : stack = sdcc_float, ret1
    ;          DEHL = sdcc_float
    ; 
    ; uses  : f, bc, de, hl

    ld hl,4                     ; stack sdcc_float
    add hl,sp

    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)                   ; DEBC = sdcc_float

    ld l,c
    ld h,b

    ret                         ; DEHL = sdcc_float

