; void sp1_GetTiles(struct sp1_Rect *r, struct sp1_tp *dest)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_GetTiles

EXTERN l0_sp1_GetTiles_callee

_sp1_GetTiles:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_sp1_GetTiles_callee
