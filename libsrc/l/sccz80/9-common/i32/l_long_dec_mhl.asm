;       Small C+ Z88 Support Library
;       Long functions
;
;       djm 26/2/2000

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_dec
PUBLIC l_long_dec_mhl


;primary = primary - 1
;enter with primary in (hl)

.l_long_dec
.l_long_dec_mhl
    ld a,$ff

    dec (hl)
    cp (hl)
    ret NZ

    inc hl
    dec (hl)
    cp (hl)
    ret NZ

    inc hl
    dec (hl)
    cp (hl)
    ret NZ

    inc hl
    dec (hl)

    ret
