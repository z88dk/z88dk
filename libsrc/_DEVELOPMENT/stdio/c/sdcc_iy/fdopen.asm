
; FILE *fdopen(int fd, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fdopen

EXTERN asm_fdopen

_fdopen:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_fdopen
