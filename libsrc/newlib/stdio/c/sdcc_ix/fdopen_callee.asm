
; FILE *fdopen_callee(int fd, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fdopen_callee, l0_fdopen_callee

EXTERN asm_fdopen

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
