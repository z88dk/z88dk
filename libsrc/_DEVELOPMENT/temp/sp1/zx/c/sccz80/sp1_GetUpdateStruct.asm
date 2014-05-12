; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)

PUBLIC sp1_GetUpdateStruct

EXTERN asm_sp1_GetUpdateStruct

sp1_GetUpdateStruct:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   
   jp asm_sp1_GetUpdateStruct
