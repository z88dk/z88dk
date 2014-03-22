
; int sscanf(const char *s, const char *format, ...)

XDEF sscanf

sscanf:

   push ix
   
   call asm_sscanf
   
   pop ix
   ret

   INCLUDE "../../z80/asm_sscanf.asm"
