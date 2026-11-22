;       Z88 Small C+ Run time Library
;
;       KR580VM1: DCMP compares the word in one byte and leaves HL alone,
;       so there is no `ld bc,de` to stage the operand as on the 8085.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_eq

.l_eq
    ; de == hl
    ; set carry if true

    cp hl,de

    scf
    ld hl,1
    ret z

    ccf
    dec l
    ret
