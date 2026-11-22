; void sp1_GetTiles(struct sp1_Rect *r, struct sp1_tp *dest)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_GetTiles_callee, l0_sp1_GetTiles_callee

EXTERN asm_sp1_GetTiles

_sp1_GetTiles_callee:

   pop af
   pop hl
   pop de
   push af

l0_sp1_GetTiles_callee:

   push de
   
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   pop hl
   
   push ix
   
   call asm_sp1_GetTiles
   
   pop ix
   ret
