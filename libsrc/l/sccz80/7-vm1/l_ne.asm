;       Z88 Small C+ Run time Library
;
;       KR580VM1: see l_eq.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_ne

.l_ne
    ; de != hl
    ; set carry if true

    cp hl,de

    scf
    ld hl,1
    ret nz

    ccf
    dec l
    ret
