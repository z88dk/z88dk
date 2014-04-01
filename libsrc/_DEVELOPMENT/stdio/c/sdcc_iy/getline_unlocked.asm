
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

XDEF getline_unlocked

getline_unlocked:

   pop af
   pop hl
   pop de
   pop ix
   
   push ix
   push de
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_getline_unlocked.asm"
