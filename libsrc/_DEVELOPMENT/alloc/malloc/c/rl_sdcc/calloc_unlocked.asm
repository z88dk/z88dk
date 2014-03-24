
; void *calloc_unlocked(size_t nmemb, size_t size)

XDEF calloc_unlocked

calloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_calloc_unlocked.asm"
