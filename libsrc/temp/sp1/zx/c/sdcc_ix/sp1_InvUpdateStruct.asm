
; sp1_InvUpdateStruct

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_InvUpdateStruct

EXTERN asm_sp1_InvUpdateStruct

_sp1_InvUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_InvUpdateStruct
