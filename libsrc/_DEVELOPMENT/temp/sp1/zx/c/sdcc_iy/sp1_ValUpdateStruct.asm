
; sp1_ValUpdateStruct

SECTION seg_code_sp1

PUBLIC _sp1_ValUpdateStruct

_sp1_ValUpdateStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/updater/asm_sp1_ValUpdateStruct.asm"
