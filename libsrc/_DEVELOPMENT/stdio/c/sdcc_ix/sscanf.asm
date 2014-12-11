
; int sscanf(const char *s, const char *format, ...)

SECTION code_stdio

PUBLIC _sscanf

_sscanf:

   push ix
   
   call asm_sscanf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_sscanf.asm"
