
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF fwrite_unlocked

fwrite_unlocked:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   exx
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_fwrite_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fwrite_unlocked.asm"
