;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
                PUBLIC    l_cm_de


.l_cm_de

   ld a,d
   or a
   ret p
   cpl
   ld d,a
   ld a,e
   cpl
   ld e,a
   inc de
   ret
   
;        ld a,d
;        or a
;        ret p
;        call    l_deneg
;        ret
