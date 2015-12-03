;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_ule

l_ule:

   ; DE <= HL [unsigned

   ; set carry if true

   ld a,h
   cp d
   
   ccf
   ret nz
   
   ld a,l
   cp e
   
   ccf
   ret
