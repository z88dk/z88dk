
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

XDEF getdelim_unlocked

getdelim_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   
   push ix
   push bc
   push de
   push hl
   push af

   INCLUDE "stdio/z80/asm_getdelim_unlocked.asm"
