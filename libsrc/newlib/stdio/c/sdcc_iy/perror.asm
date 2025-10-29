
; void perror(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _perror

EXTERN asm_perror

_perror:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_perror
