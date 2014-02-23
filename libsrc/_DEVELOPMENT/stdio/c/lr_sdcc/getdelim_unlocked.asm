
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

XDEF getdelim_unlocked

getdelim_unlocked:

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
   
   call asm_getdelim_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_getdelim_unlocked.asm"
