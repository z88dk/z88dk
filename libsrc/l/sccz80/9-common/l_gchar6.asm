;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_gchar6

l_gchar6:
   ld bc,6
   add hl,bc

   ; fetch char from (HL) and sign extend into HL
   ld a,(hl)

   ; sign extend a into hl
   ld l,a
   
   rlca
   sbc a,a
   ld h,a
   
   ret
