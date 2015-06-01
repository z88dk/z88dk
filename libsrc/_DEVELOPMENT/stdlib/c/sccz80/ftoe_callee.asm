
; size_t ftoe(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_stdlib

PUBLIC ftoe_callee

EXTERN dcollect1

ftoe_callee:

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   call dcollect1
   
   INCLUDE "stdlib/z80/asm_ftoe.asm"
