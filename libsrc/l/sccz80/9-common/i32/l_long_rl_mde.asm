;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_rl_mde


;primary = primary<<1
;enter with primary in (de)

.l_long_rl_mde
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
