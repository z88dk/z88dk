
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

XDEF getdelim

getdelim:

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

   INCLUDE "stdio/z80/asm_getdelim.asm"
