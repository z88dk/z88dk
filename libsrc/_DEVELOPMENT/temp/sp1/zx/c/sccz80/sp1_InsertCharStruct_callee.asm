
; void __CALLEE__ sp1_InsertCharStruct_callee(struct sp1_update *u, struct sp1_cs *cs)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_temp_sp1

PUBLIC sp1_InsertCharStruct_callee

sp1_InsertCharStruct_callee:

   pop hl
   pop de
   ex (sp),hl
   ex de,hl

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_InsertCharStruct.asm"
