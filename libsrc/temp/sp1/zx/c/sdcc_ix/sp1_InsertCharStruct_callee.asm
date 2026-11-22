; void sp1_InsertCharStruct(struct sp1_update *u, struct sp1_cs *cs)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_InsertCharStruct_callee

EXTERN asm_sp1_InsertCharStruct

_sp1_InsertCharStruct_callee:

   pop af
   pop de
   pop hl
   push af

   jp asm_sp1_InsertCharStruct
