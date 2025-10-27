; void sp1_SetPrintPos(struct sp1_pss *ps, uchar row, uchar col)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_SetPrintPos

EXTERN asm_sp1_SetPrintPos

_sp1_SetPrintPos:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   ld d,c
   jp asm_sp1_SetPrintPos
