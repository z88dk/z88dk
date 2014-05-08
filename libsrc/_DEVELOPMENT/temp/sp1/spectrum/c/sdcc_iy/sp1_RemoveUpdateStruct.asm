
; sp1_RemoveUpdateStruct

PUBLIC _sp1_RemoveUpdateStruct

_sp1_RemoveUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_RemoveUpdateStruct.asm"
