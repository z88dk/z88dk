
; int fclose_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _fclose_unlocked_fastcall

_fclose_unlocked_fastcall:

   push hl
   ex (sp),ix
   
   call asm_fclose_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fclose_unlocked.asm"
