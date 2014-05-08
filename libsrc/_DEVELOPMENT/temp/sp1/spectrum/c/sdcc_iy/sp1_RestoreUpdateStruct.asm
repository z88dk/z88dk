
; sp1_RestoreUpdateStruct

PUBLIC _sp1_RestoreUpdateStruct

_sp1_RestoreUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_RestoreUpdateStruct.asm"
