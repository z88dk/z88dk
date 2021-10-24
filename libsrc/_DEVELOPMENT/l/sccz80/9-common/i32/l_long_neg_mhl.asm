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
    ld      a,(hl)
    cpl
    inc     a
    ld      (hl),a

    inc     hl

    ld      a,(hl)
    cpl
    jp      NZ,neg1
    inc     a
.neg1
    ld      (hl),a

    inc     hl

    ld      a,(hl)
    cpl
    jp      NZ,neg2
    inc     a
.neg2
    ld      (hl),a

    inc     hl

    ld      a,(hl)
    cpl
    jp      NZ,neg3
    inc     a
.neg3
    ld      (hl),a

    ret
