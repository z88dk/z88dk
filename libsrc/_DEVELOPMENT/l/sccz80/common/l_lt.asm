;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_lt
EXTERN l_compare_result

l_lt:

   ; DE < HL [signed

   ; set carry if true

   ld a,h
   add a,$80
   ld b,a
   
   ld a,d
   add a,$80
   
   cp b
   jp nz, l_compare_result
   
   ld a,e
   cp l
   
   jp l_compare_result
