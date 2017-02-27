;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION   code_crt0_sccz80
PUBLIC    l_gt
EXTERN    l_compare_result

;
; DE > HL [signed]
; set carry if true

.l_gt

   ld a,d
   add a,$80
   ld b,a
   ld a,h
   add a,$80
   
   cp b
   jp nz, l_compare_result
   ld a,l
   cp e
   jp l_compare_result

;        ex de,hl
;        call    l_cmp
;        ret   c
;        ret
