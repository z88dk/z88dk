; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)

XLIB sp1_GetUpdateStruct

LIB asm_sp1_GetUpdateStruct

sp1_GetUpdateStruct:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   
   jp asm_sp1_GetUpdateStruct
