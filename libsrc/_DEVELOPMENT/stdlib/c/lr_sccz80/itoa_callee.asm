
; char *itoa(int num, char *buf, int radix)

XDEF itoa_callee

itoa_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdlib/z80/asm_itoa.asm"
