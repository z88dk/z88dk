;       Z88 Small C+ Run time Library
;
;       KR580VM1: see l_gint.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint6

; HL = (HL + 6)

.l_gint6
    ld bc,6
    add hl,bc
    ex de,hl
    ld hl,(de)
    ret
