; uint __CALLEE__ sp1_AddColSpr_callee(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane)

PUBLIC sp1_AddColSpr_callee

sp1_AddColSpr_callee:

   pop af
   pop hl
   ld h,l
   pop bc
   pop de
   ld l,e
   pop de
   pop ix
   push af

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_AddColSpr.asm"
