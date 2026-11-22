
; sp1_RestoreUpdateStruct

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_RestoreUpdateStruct

EXTERN asm_sp1_RestoreUpdateStruct

_sp1_RestoreUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_RestoreUpdateStruct
