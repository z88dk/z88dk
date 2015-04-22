
; FILE *fopen_callee(const char *filename, const char *mode)

SECTION code_stdio

PUBLIC _fopen_callee

_fopen_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_fopen.asm"
