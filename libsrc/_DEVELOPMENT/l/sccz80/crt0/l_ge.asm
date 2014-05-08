;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

PUBLIC    l_ge

;
; DE >= HL [signed]
; set carry if true

.l_ge

   ld a,h
   add a,$80
   ld b,a
   ld a,d
   add a,$80
   
   cp b
   ccf
   ret nz
   ld a,e
   cp l
   ccf
   ret

;        call    l_cmp
;invert carry condition
;        ccf
;        ret
