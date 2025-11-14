
; sp1_RemoveUpdateStruct

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_RemoveUpdateStruct

EXTERN asm_sp1_RemoveUpdateStruct

_sp1_RemoveUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_RemoveUpdateStruct
