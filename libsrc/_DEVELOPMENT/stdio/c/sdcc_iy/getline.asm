
; size_t getline(char **lineptr, size_t *n, FILE *stream)

XDEF getline

getline:

   pop af
   pop hl
   pop de
   pop ix
   
   push ix
   push de
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_getline.asm"
