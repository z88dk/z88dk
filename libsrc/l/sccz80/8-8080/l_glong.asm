;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_glong
PUBLIC    l_glonghlp

;Fetch long dehl from (hl)

.l_glonghlp
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a

.l_glong
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex de,hl
    ret
