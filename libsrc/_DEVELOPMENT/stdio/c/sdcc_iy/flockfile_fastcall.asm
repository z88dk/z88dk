
; void flockfile_fastcall(FILE *file)

SECTION code_stdio

PUBLIC _flockfile_fastcall

_flockfile_fastcall:
   
   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_flockfile.asm"
