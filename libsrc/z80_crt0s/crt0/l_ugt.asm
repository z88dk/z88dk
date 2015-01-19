;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

PUBLIC    l_ugt

;
; DE > HL [unsigned]
; set carry if true

.l_ugt

   ld a,h
   cp d
   ret nz
   ld a,l
   cp e
   ret

;        ex      de,hl
;        jp	l_ucmp
