;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gt

l_gt:

   ; DE > HL [signed

   ; set carry if true

   ld a,d
   add a,$80
   ld b,a
   
   ld a,h
   add a,$80
   
   cp b
   ret nz
   
   ld a,l
   cp e
   
   ret
