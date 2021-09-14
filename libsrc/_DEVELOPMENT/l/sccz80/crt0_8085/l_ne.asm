;       Z88 Small C+ Run time Library
;       sccz80 crt0 library - 8085 version

SECTION   code_crt0_sccz80

PUBLIC    l_ne

; DE != HL
; set carry if true

.l_ne
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    or l

    ld hl,1
    scf
    ret NZ

    xor a
    dec l
    ret
