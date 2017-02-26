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
   ; set carry if result is zero

   ld a,h
   or l
	ld hl,0
   ret nz
   
   scf
	inc l
   ret
