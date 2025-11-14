;       Z88 Small C+ Run time Library
;       sccz80 crt0 library - 8080 version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_ne

; DE != HL
; set carry if true

.l_ne
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a
    or l
    ld hl,1
    scf
    ret nz

    xor a
    dec l
    ret
