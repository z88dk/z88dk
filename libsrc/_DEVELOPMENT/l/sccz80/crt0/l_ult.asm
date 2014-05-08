;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                PUBLIC    l_ult

;
; DE < HL [unsigned]
; set carry if true

.l_ult

   ld a,d
   cp h
   ret nz
   ld a,e
   cp l
   ret

