
; int sscanf(const char *s, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _sscanf

EXTERN asm_sscanf

_sscanf:

   push ix
   
   call asm_sscanf
   
   pop ix
   ret
