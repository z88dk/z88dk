;       Z88 Small C+ Run time Library
;
;       KR580VM1: see l_gint.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gintsp, l_gintsp_gint

; HL = (sp + HL + 2)

.l_gintsp
    add hl,sp
    inc hl
    inc hl
.l_gintsp_gint
    ex de,hl
    ld hl,(de)
    ret
