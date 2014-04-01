
; void *_falloc_unlocked(void *p, size_t size)

XDEF _falloc_unlocked

_falloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc_unlocked.asm"
