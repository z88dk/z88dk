; void sp1_InsertCharStruct(struct sp1_update *u, struct sp1_cs *cs)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_InsertCharStruct

EXTERN asm_sp1_InsertCharStruct

_sp1_InsertCharStruct:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_sp1_InsertCharStruct
