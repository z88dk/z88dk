
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

PUBLIC _aligned_alloc_unlocked

_aligned_alloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_aligned_alloc_unlocked.asm"
