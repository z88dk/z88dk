; void sp1_PrintAtInv(uchar row, uchar col, uchar colour, uint tile)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PrintAtInv_callee

EXTERN asm_sp1_PrintAtInv

_sp1_PrintAtInv_callee:

   pop hl
   pop de
   ld d,e
   pop bc
   ld e,c
   pop bc
   ld a,c
   pop bc
   push hl

   jp asm_sp1_PrintAtInv
