; void sp1_PutTiles(struct sp1_Rect *r, struct sp1_tp *src)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PutTiles

EXTERN l0_sp1_PutTiles_callee

_sp1_PutTiles:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_sp1_PutTiles_callee
