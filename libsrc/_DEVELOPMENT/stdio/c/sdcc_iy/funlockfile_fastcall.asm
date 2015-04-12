
; void funlockfile_fastcall(FILE *file)

SECTION code_stdio

PUBLIC _funlockfile_fastcall

_funlockfile_fastcall:
   
   push hl
   pop ix
      
   INCLUDE "stdio/z80/asm_funlockfile.asm"
