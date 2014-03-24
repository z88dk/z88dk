
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

XDEF aligned_alloc_unlocked

aligned_alloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_aligned_alloc_unlocked.asm"
