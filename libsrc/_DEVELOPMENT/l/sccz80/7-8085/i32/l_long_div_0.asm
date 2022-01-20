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

    ld      de,sp+14            ;rotate left dividend + quotient Carry

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

    ld      de,sp+4             ;rotate left remainder + dividend Carry

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

    ld      de,sp+8             ;compare (remainder - divisor)
    ex      de,hl
    ld      de,sp+4

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

    ld      de,sp+8             ;subtract (remainder - divisor)
    ex      de,hl
    ld      de,sp+4

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

    ld      de,sp+14            ;rotate left quotient Carry

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

    ret

