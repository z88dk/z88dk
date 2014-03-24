
; void *aligned_alloc(size_t alignment, size_t size)

XDEF aligned_alloc

aligned_alloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_aligned_alloc.asm"
