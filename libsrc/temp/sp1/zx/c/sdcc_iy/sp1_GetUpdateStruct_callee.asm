; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_GetUpdateStruct_callee

EXTERN asm_sp1_GetUpdateStruct

_sp1_GetUpdateStruct_callee:

   pop af
   pop bc
   pop de
   push af
   
   ld d,c
   jp asm_sp1_GetUpdateStruct
