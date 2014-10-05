
; char *utoa(unsigned int num, char *buf, int radix)

SECTION seg_code_stdlib

PUBLIC utoa_callee

utoa_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdlib/z80/asm_utoa.asm"
