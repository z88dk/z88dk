
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

XLIB getdelim

getdelim:

   pop af
   exx
   pop bc
   exx
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   exx
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_getdelim
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getdelim.asm"
