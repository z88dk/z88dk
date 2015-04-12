
; int ferror_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _ferror_unlocked_fastcall

_ferror_unlocked_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_ferror_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ferror_unlocked.asm"
