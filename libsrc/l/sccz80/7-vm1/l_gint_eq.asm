;       Z88 Small C+ Run time Library
;
;       KR580VM1: see l_gint. The zero test still has to go through A.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint_eq

; HL = (HL), z set if the word is zero

.l_gint_eq
    ex de,hl
    ld hl,(de)
    ld a,l
    or h
    ret
