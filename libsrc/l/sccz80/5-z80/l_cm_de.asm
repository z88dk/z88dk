
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_cm_de

.l_cm_de

   bit 7,d
   ret z
   ld a,d
   cpl
   ld d,a
   ld a,e
   cpl
   ld e,a
   inc de
   ret
