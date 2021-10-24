;       Small C+ Z88 Support Library
;       Long functions
;
;       djm 26/2/2000
;       aralbrec 01/2007

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_inc
PUBLIC  l_long_inc_mhl


;primary = primary + 1
;enter with primary in (hl)

.l_long_inc
.l_long_inc_mhl
    inc (hl)
    ret NZ

    inc hl
    inc (hl)
    ret NZ

    inc hl
    inc (hl)
    ret NZ

    inc hl
    inc (hl)

    ret
