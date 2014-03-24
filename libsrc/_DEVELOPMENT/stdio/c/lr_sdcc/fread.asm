
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF fread

fread:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   exx
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_fread
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fread.asm"
