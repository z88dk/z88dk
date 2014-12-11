
; sp1_RestoreUpdateStruct

SECTION code_temp_sp1

PUBLIC _sp1_RestoreUpdateStruct

_sp1_RestoreUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/updater/asm_sp1_RestoreUpdateStruct.asm"
