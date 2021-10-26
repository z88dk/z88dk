;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_rl_mhl


;primary = primary<<1
;enter with primary in (hl)

.l_long_rl_mhl
    ld      a,(hl)
    rla
    ld      (hl+),a

    ld      a,(hl)
    rla
    ld      (hl+),a

    ld      a,(hl)
    rla
    ld      (hl+),a

    ld      a,(hl)
    rla
    ld      (hl),a

    ret
