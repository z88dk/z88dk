
; FILE *fopen(const char *filename, const char *mode)

SECTION code_stdio

PUBLIC _fopen

_fopen:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_fopen.asm"
