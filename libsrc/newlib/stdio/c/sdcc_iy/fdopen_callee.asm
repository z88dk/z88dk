
; FILE *fdopen_callee(int fd, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fdopen_callee

EXTERN asm_fdopen

_fdopen_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_fdopen
