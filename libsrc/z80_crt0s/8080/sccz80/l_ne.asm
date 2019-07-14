;       Z88 Small C+ Run time Library

                SECTION   code_crt0_sccz80
                PUBLIC    l_ne
;
; DE != HL
; set carry if true

.l_ne
        ld      a,l
        sub     e
        ld      l,a
        ld      a,h
        sbc     d
        ld      h,a
        or      l
        inc     hl
        scf
        ret     nz
        xor     a
        ld      l,a
        ld      h,a
        ret
