
; void *calloc_unlocked(size_t nmemb, size_t size)

XDEF calloc_unlocked

calloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_calloc_unlocked.asm"
