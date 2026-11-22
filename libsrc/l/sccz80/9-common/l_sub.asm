;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_sub

; HL = DE - HL

.l_sub
    ld a,e
    sub l
    ld l,a
    ld a,d
    sbc a,h
    ld h,a
    ret
