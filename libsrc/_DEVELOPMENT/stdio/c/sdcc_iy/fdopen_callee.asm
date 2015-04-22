
; FILE *fdopen_callee(int fd, const char *mode)

SECTION code_stdio

PUBLIC _fdopen_callee

_fdopen_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_fdopen.asm"
