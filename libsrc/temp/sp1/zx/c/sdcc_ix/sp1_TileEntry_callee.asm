; void *sp1_TileEntry(uchar c, void *def)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_TileEntry_callee

EXTERN asm_sp1_TileEntry

_sp1_TileEntry_callee:

   pop af
   pop bc
   pop de
   push af

   jp asm_sp1_TileEntry
