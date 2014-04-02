
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF _fwrite

_fwrite:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push bc
   push hl
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
      
   call asm_fwrite
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fwrite.asm"
