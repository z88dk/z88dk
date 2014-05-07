; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)

XDEF _sp1_GetUpdateStruct

_sp1_GetUpdateStruct:

   ld hl,2
   add hl,sp
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   
   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_GetUpdateStruct.asm"
