
; sp1_RemoveUpdateStruct

SECTION code_temp_sp1

PUBLIC _sp1_RemoveUpdateStruct

_sp1_RemoveUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/updater/asm_sp1_RemoveUpdateStruct.asm"
