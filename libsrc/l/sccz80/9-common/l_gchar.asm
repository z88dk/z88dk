;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gchar, l_gchar_sxt
PUBLIC l_gchar1, l_gchar2, l_gchar3

l_gchar3:
   inc hl
l_gchar2:
   inc hl
l_gchar1:
   inc hl
l_gchar:

   ; fetch char from (HL) and sign extend into HL

   ld a,(hl)

l_gchar_sxt:

   ; sign extend a into hl
   
   ld l,a
   
   rlca
   sbc a,a
   ld h,a
   
   ret
