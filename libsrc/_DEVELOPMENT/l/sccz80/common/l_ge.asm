;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_ge
EXTERN l_compare_result

l_ge:

   ; DE >= HL [signed

   ; set carry if true

   ld a,h
   add a,$80
   ld b,a
   
   ld a,d
   add a,$80
   
   cp b
   ccf
   jp nz, l_compare_result
   
   ld a,e
   cp l
   ccf
   
   jp l_compare_result
