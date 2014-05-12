
; sp1_InvUpdateStruct

PUBLIC _sp1_InvUpdateStruct

_sp1_InvUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/updater/asm_sp1_InvUpdateStruct.asm"
