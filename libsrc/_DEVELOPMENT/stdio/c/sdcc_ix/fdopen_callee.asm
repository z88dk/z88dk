
; FILE *fdopen_callee(int fd, const char *mode)

SECTION code_stdio

PUBLIC _fdopen_callee, l0_fdopen_callee

_fdopen_callee:

   pop af
   pop hl
   pop de
   push af

l0_fdopen_callee:

   push ix
   
   call asm_fdopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fdopen.asm"
