;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
                PUBLIC    l_gint


.l_gint
        ld a,(hl)
        inc     hl
        ld h,(hl)
        ld l,a
        ret
