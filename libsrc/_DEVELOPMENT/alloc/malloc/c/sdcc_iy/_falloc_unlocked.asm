
; void *_falloc_unlocked(void *p, size_t size)

XDEF __falloc_unlocked

__falloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc_unlocked.asm"
