
; FILE *fopen(const char *filename, const char *mode)

SECTION seg_code_stdio

PUBLIC _fopen

_fopen:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_fopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fopen.asm"
