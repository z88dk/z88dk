;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm


                SECTION   code_crt0_sccz80
                PUBLIC    l_asl


; shift DE left arithmetically by HL, move to HL

.l_asl 
        ld a,l
        ld l,e
        ld h,d
.l_asl1   
        and   15
        ret   z
        add   hl,hl
        dec   a
        jp    l_asl1
