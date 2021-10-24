;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_neg_mde


;primary = - primary
;enter with primary in (de)

.l_long_neg_mde
    ld      a,(de)
    cpl
    inc     a
    ld      (de),a

    inc     de

    ld      a,(de)
    cpl
    jp      NZ,neg1
    inc     a
.neg1
    ld      (de),a

    inc     de

    ld      a,(de)
    cpl
    jp      NZ,neg2
    inc     a
.neg2
    ld      (de),a

    inc     de

    ld      a,(de)
    cpl
    jp      NZ,neg3
    inc     a
.neg3
    ld      (de),a

    ret
