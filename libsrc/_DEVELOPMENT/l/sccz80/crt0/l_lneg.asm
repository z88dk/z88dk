;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_lneg

l_lneg:

   ; HL = !HL
   ; set carry if result true

   ld a,h
   or l
   ret nz
   
   scf
   ret
