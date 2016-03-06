;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_bool


; HL = !!HL

.l_long_bool
        ld a,h
        or l
        or e
        or d
        ret z
        ld hl,1
        ld e,h
        ld d,h
        ret
