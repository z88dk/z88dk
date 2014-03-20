
; void *calloc(size_t nmemb, size_t size)

XDEF calloc

calloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_calloc.asm"
