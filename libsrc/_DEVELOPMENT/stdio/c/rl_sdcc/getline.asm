
; size_t getline(char **lineptr, size_t *n, FILE *stream)

XDEF getline

getline:

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
   
   call asm_getline
   
   pop ix
   ret

   INCLUDE "../../z80/asm_getline.asm"
