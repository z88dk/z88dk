
; int fseek(FILE *stream, long offset, int whence)

XDEF _fseek

_fseek:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fseek.asm"
