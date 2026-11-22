
; FILE *fdopen(int fd, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fdopen

EXTERN l0_fdopen_callee

_fdopen:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_fdopen_callee
