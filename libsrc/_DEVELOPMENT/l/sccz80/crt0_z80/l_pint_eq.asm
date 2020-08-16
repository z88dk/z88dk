;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;	Optimization...check for equality

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_pint_eq

l_pint_eq:

   ld a,l
   
   ld (de),a
   inc de
   
   ld a,h
   ld (de),a
   
   or l
   ret
