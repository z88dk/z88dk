
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

XDEF getline_unlocked

getline_unlocked:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_getline_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_getline_unlocked.asm"
