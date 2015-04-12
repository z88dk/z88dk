
; int system_fastcall(const char *string)

SECTION code_stdlib

PUBLIC _system_fastcall

_system_fastcall:
   
   push ix
   
   call asm_system
   
   pop ix
   ret

   INCLUDE "stdlib/z80/asm_system.asm"
