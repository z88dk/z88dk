;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
                PUBLIC    l_cm_bc

.l_cm_bc

   ld a,b
   or a
   ret p
   cpl
   ld b,a
   ld a,c
   cpl
   ld c,a
   inc bc
   ret


;        ld a,b
;        or a
;        ret p
;        call    l_bcneg
;        ret
