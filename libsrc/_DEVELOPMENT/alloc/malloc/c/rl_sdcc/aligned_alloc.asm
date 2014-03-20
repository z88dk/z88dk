
; void *aligned_alloc(size_t alignment, size_t size)

XDEF aligned_alloc

aligned_alloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_aligned_alloc.asm"
