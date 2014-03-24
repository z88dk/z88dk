
; void *aligned_alloc(size_t alignment, size_t size)

XDEF aligned_alloc_callee

aligned_alloc_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_aligned_alloc.asm"
