;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       13/5/99 djm, inverted carry conditions

PUBLIC    l_uge

;
; DE >= HL [unsigned]
; set carry if true


.l_uge

   ld a,d
   cp h
   ccf
   ret nz
   ld a,e
   cp l
   ccf
   ret

;        call    l_ucmp
;        ccf
;	ret

