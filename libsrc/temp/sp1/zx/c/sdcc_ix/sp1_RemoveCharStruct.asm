
; void  sp1_RemoveCharStruct(struct sp1_cs *cs)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_RemoveCharStruct

EXTERN asm_sp1_RemoveCharStruct

_sp1_RemoveCharStruct:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_RemoveCharStruct
