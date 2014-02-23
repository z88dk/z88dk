
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF fread_callee

fread_callee:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_fread.asm"
