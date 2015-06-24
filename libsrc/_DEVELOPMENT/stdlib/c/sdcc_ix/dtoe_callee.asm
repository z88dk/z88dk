
; size_t dtoe(double x, char *buf, uint16_t prec, uint16_t flag) __z88dk_callee

SECTION code_stdlib

PUBLIC _dtoe_callee, l0_dtoe_callee

EXTERN dcallee1

_dtoe_callee:

   call dcallee1               ; AC' = x
   
   pop af
   pop hl
   pop de
   pop bc
   push af

l0_dtoe_callee:

   push ix
   
   call asm_dtoe
   
   pop ix
   ret

   INCLUDE "stdlib/z80/asm_dtoe.asm"
