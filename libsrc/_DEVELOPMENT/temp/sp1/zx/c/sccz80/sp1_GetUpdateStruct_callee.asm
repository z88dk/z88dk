; struct sp1_update __CALLEE__ *sp1_GetUpdateStruct_callee(uchar row, uchar col)

PUBLIC sp1_GetUpdateStruct_callee

sp1_GetUpdateStruct_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

   INCLUDE "temp/sp1/zx/updater/asm_sp1_GetUpdateStruct.asm"
