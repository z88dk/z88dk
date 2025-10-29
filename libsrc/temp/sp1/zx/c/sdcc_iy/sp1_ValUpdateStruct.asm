
; sp1_ValUpdateStruct

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_ValUpdateStruct

EXTERN asm_sp1_ValUpdateStruct

_sp1_ValUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_ValUpdateStruct
