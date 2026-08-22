;       Z88 Small C+ Run time Library
;
;       KR580VM1: see l_gint.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint4

; HL = (HL + 4)

.l_gint4
    ld bc,4
    add hl,bc
    ex de,hl
    ld hl,(de)
    ret
