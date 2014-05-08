
; sp1_ValUpdateStruct

PUBLIC _sp1_ValUpdateStruct

_sp1_ValUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_ValUpdateStruct.asm"
