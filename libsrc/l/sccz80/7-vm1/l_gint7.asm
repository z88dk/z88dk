;       Z88 Small C+ Run time Library
;
;       KR580VM1: see l_gint.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint7

; HL = (HL + 7)

.l_gint7
    ld bc,7
    add hl,bc
    ex de,hl
    ld hl,(de)
    ret
