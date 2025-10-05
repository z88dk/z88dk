
; int fprintf_unlocked(FILE *stream, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _fprintf_unlocked

EXTERN asm_fprintf_unlocked

_fprintf_unlocked:

   push ix
   
   call asm_fprintf_unlocked
   
   pop ix
   ret
