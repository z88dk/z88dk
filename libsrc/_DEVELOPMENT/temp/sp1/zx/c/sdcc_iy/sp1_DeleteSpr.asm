
; void __FASTCALL__ sp1_DeleteSpr(struct sp1_ss *s)

SECTION code_temp_sp1

PUBLIC _sp1_DeleteSpr

_sp1_DeleteSpr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_DeleteSpr.asm"
