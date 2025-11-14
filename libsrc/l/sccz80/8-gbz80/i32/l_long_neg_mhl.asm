;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_neg_mhl


;primary = - primary
;enter with primary in (hl)

.l_long_neg_mhl
    ld      a,0
    sub     a,(hl)
    ld      (hl+),a

    ld      a,0
    sbc     a,(hl)
    ld      (hl+),a

    ld      a,0
    sbc     a,(hl)
    ld      (hl+),a

    ld      a,0
    sbc     a,(hl)
    ld      (hl),a

    ret
