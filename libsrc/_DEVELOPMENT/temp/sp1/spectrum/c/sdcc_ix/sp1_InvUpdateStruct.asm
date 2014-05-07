
; sp1_InvUpdateStruct

XDEF _sp1_InvUpdateStruct

_sp1_InvUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_InvUpdateStruct.asm"
