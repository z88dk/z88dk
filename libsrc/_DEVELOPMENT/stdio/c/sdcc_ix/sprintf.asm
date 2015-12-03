
; int sprintf(char *s, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _sprintf

EXTERN asm_sprintf

_sprintf:

   push ix
   
   call asm_sprintf
   
   pop ix
   ret
