
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF _fread

_fread:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   
   push ix
   push hl
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_fread.asm"
