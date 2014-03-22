
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF fwrite

fwrite:

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
   
   call asm_fwrite
   
   pop ix
   ret

   INCLUDE "../../z80/asm_fwrite.asm"
