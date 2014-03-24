
; size_t getline(char **lineptr, size_t *n, FILE *stream)

XDEF getline

getline:

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
   
   call asm_getline
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_getline.asm"
