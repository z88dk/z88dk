;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
                PUBLIC    l_or

; "or" HL and DE into HL
.l_or  
        ld a,l
        or e
        ld l,a
        ld a,h
        or d
        ld h,a
        ret

