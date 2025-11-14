;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021


SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_div_0

.l_long_div_0
    ld      b,32                ;set up div_loop counter

.div_loop
    rra                         ;save Carry
    ld      hl,sp+4             ;remainder (hl)
    ex      de,hl
    ld      hl,sp+14            ;dividend (hl)
    rla                         ;restore Carry

    ;rotate left dividend + quotient Carry
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a

    ;rotate left remainder + dividend Carry
    ld      a,(de)
    rla
    ld      (de),a
    inc     de
    ld      a,(de)
    rla
    ld      (de),a
    inc     de
    ld      a,(de)
    rla
    ld      (de),a
    inc     de
    ld      a,(de)
    rla
    ld      (de),a

    ;compare (remainder - divisor)
    ld      hl,sp+4
    ex      de,hl
    ld      hl,sp+8

    ld      a,(de)
    sub     a,(hl)
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)

    jp      C,skip_subtract     ;skip if remainder < divisor
    
    ;subtract (remainder - divisor)
    ld      hl,sp+4 
    ex      de,hl
    ld      hl,sp+8

    ld      a,(de)
    sub     a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    ld      (de),a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    ld      (de),a

.skip_subtract
    ccf                         ;prepare Carry for quotient

    dec     b
    jp      NZ,div_loop

    rra                         ;save Carry
    ld      hl,sp+14
    rla                         ;restore Carry

    ld      a,(hl)              ;rotate left quotient Carry
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a

    ret

