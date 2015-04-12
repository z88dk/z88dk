
; int fflush_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _fflush_unlocked_fastcall

_fflush_unlocked_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_fflush_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fflush_unlocked.asm"
