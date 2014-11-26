; void sp1_InsertCharStruct(struct sp1_update *u, struct sp1_cs *cs)

SECTION seg_code_sp1

PUBLIC _sp1_InsertCharStruct

_sp1_InsertCharStruct:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_InsertCharStruct.asm"
