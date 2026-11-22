;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_cpl_mhl


;primary = 1s complement primary
;enter with primary in (hl)

.l_long_cpl_mhl
    ld      a,(hl)
    cpl
    ld      (hl+),a

    ld      a,(hl)
    cpl
    ld      (hl+),a

    ld      a,(hl)
    cpl
    ld      (hl+),a

    ld      a,(hl)
    cpl
    ld      (hl),a

    ret
