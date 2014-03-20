
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

XDEF aligned_alloc_unlocked

aligned_alloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_aligned_alloc_unlocked.asm"
