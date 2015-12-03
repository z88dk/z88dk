
; void perror_fastcall(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _perror_fastcall

EXTERN asm_perror

_perror_fastcall:

   push ix
   
   call asm_perror
   
   pop ix
   ret
