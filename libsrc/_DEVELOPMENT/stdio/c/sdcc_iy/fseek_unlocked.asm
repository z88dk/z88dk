
; int fseek_unlocked(FILE *stream, long offset, int whence)

XDEF fseek_unlocked

fseek_unlocked:

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
   
   INCLUDE "stdio/z80/asm_fseek_unlocked.asm"
