
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

PUBLIC _getline_unlocked

_getline_unlocked:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_getline_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_getline_unlocked.asm"
