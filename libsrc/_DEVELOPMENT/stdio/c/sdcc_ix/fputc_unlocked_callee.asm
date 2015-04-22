
; int fputc_unlocked_callee(int c, FILE *stream)

SECTION code_stdio

PUBLIC _fputc_unlocked_callee, l0_fputc_unlocked_callee

_fputc_unlocked_callee:

   pop hl
   pop de
   ex (sp),hl

l0_fputc_unlocked_callee:

   push hl
   ex (sp),ix
   
   call asm_fputc_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputc_unlocked.asm"
