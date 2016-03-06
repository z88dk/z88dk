;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_com


; deHL = ~deHL
.l_long_com 
        ld a,h
        cpl
        ld h,a
        ld a,l
        cpl
        ld l,a
        ld      a,d
        cpl
        ld      d,a
        ld      a,e
        cpl     
        ld      e,a
        ret

