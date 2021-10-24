;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_cpl_mde


;primary = 1s complement primary
;enter with primary in (de)

.l_long_cpl_mde
    ld      a,(de)
    cpl
    ld      (de),a

    inc     de

    ld      a,(de)
    cpl
    ld      (de),a

    inc     de

    ld      a,(de)
    cpl
    ld      (de),a

    inc     de

    ld      a,(de)
    cpl
    ld      (de),a

    ret
