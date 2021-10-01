;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;       13/5/99 djm Added carry conditions...

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_eq

l_eq:

   ; de == hl
   ; carry set if true
   
   or a
   sbc hl,de
   
   scf
	inc hl
   ret z
	
   xor a
   ld l,a
   ld h,a
   ret
