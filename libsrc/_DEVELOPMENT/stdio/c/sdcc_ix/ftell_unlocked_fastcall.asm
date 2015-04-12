
; unsigned long ftell_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _ftell_unlocked_fastcall

_ftell_unlocked_fastcall:

   push hl
   ex (sp),ix
   
   call asm_ftell_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ftell_unlocked.asm"
