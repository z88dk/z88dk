;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm


SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_asl


; shift DE left arithmetically by HL, move to HL

.l_asl
    ex de,hl
.l_asl1
    dec   e
    ret   M
    add   hl,hl
    jp    l_asl1
