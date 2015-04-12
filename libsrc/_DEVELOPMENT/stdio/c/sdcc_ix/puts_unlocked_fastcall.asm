
; int puts_unlocked_fastcall(const char *s)

SECTION code_stdio

PUBLIC _puts_unlocked_fastcall

_puts_unlocked_fastcall:

   push ix
   
   call asm_puts_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_puts_unlocked.asm"
