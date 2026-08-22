;       Z88 Small C+ Run time Library
;
;       KR580VM1: LHLX reads the word through DE in one instruction, so the
;       byte walk goes. A survives, where the common version destroys it.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint, l_gint1, l_gint2, l_gint3

; HL = (HL). DE is left holding the address - see the README on why that is
; affordable here.

.l_gint3
    inc hl
.l_gint2
    inc hl
.l_gint1
    inc hl
.l_gint
    ex de,hl
    ld hl,(de)
    ret
