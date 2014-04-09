
; FILE *fopen(const char *filename, const char *mode);

XDEF _fopen

_fopen:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   push ix
   
   call asm_fopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fopen.asm"
