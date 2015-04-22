
; FILE *fopen_callee(const char *filename, const char *mode)

SECTION code_stdio

PUBLIC _fopen_callee, l0_fopen_callee

_fopen_callee:

   pop af
   pop hl
   pop de
   push af

l0_fopen_callee:

   push ix
   
   call asm_fopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fopen.asm"
