;       Z88 Small C+ Run time Library
;
;       KR580VM1: DCMP sets CY and Z from HL - DE without touching
;       either pair, so the 8085's `ld bc,de` staging move goes.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_uge

EXTERN l_compare_true
EXTERN l_compare_false

.l_uge
    ; DE >= HL [unsigned]
    ; set carry if true

    cp hl,de

    jp c,l_compare_true
    jp z,l_compare_true
    jp l_compare_false
