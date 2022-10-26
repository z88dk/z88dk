
SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_cm_bc

.l_cm_bc

   bit 7,b
   ret z
   ld a,b
   cpl
   ld b,a
   ld a,c
   cpl
   ld c,a
   inc bc
   ret
