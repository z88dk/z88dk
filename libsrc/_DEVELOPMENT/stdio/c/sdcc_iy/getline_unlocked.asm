
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

SECTION seg_code_stdio

PUBLIC _getline_unlocked

_getline_unlocked:

   pop af
   pop hl
   pop de
   pop ix
   
   push ix
   push de
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_getline_unlocked.asm"
