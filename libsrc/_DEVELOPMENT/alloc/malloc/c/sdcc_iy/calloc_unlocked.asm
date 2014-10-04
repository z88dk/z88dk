
; void *calloc_unlocked(size_t nmemb, size_t size)

SECTION seg_code_malloc

PUBLIC _calloc_unlocked

_calloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_calloc_unlocked.asm"
