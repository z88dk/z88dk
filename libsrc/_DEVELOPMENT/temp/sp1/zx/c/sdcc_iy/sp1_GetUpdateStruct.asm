; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_GetUpdateStruct

EXTERN asm_sp1_GetUpdateStruct

_sp1_GetUpdateStruct:

   ld hl,2
   add hl,sp
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   
   jp asm_sp1_GetUpdateStruct
