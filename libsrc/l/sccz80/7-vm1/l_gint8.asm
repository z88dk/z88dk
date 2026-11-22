;       Z88 Small C+ Run time Library
;
;       KR580VM1: see l_gint.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint8

; HL = (HL + 8)

.l_gint8
    ld bc,8
    add hl,bc
    ex de,hl
    ld hl,(de)
    ret
