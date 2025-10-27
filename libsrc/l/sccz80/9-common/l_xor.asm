;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_xor

l_xor:

   ; "xor" HL and DE into HL

   ld a,l
   xor e
   ld l,a
   
   ld a,h
   xor d
   ld h,a
   
   ret
