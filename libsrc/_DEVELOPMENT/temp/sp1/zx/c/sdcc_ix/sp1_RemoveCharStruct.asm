
; void  sp1_RemoveCharStruct(struct sp1_cs *cs)

SECTION seg_code_sp1

PUBLIC _sp1_RemoveCharStruct

_sp1_RemoveCharStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_RemoveCharStruct.asm"
