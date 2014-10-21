
; FILE *fdopen(int fd, const char *mode)

SECTION seg_code_stdio

PUBLIC _fdopen

_fdopen:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_fdopen.asm"
