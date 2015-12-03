;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       13/5/99 djm, inverted carry conditions

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_uge

l_uge:

   ; DE >= HL [unsigned

   ; set carry if true

   ld a,d
   cp h
   
   ccf
   ret nz
   
   ld a,e
   cp l
   
   ccf
   ret
