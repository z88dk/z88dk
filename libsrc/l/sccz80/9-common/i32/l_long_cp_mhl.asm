;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_cp_mhl


;primary = primary (- secondary)
;enter with secondary in (hl), primary in (de)

.l_long_cp_mhl
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

    ret
