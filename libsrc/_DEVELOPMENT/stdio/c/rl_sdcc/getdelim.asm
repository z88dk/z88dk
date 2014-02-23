
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

XDEF getdelim

getdelim:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   
   push bc
   exx
   push bc
   push de
   push hl
   push af
   

   push ix

   exx   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_getdelim
   
   pop ix
   ret

   INCLUDE "../../z80/asm_getdelim.asm"
