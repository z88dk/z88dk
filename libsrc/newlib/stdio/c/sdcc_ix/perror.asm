
; void perror(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _perror

EXTERN _perror_fastcall

_perror:

   pop af
   pop hl
   
   push hl
   push af

   jp _perror_fastcall
