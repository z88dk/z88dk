
; void  sp1_RemoveCharStruct(struct sp1_cs *cs)

XDEF _sp1_RemoveCharStruct

_sp1_RemoveCharStruct:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_RemoveCharStruct.asm"
