
; size_t ftoa(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_stdlib

PUBLIC ftoa_callee

EXTERN dcollect1

ftoa_callee:

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   call dcollect1
   
   INCLUDE "stdlib/z80/asm_ftoa.asm"
