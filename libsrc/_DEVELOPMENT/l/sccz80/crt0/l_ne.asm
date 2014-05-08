;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                PUBLIC    l_ne

                EXTERN     l_cmp

;
; DE != HL
; set carry if true

.l_ne

   or a
   sbc hl,de
   scf
   ret nz
   ccf
   ret

;        call    l_cmp
;        scf
;        ret   nz
;        ccf
;        ret
