;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       13/5/99 djm Optimizer routine to test against zero
;       Returns z=0 nz otherwise as well as the int in hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gint_eq

l_gint_eq:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   ret
