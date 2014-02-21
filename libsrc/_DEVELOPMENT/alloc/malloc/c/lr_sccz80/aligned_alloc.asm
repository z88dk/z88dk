
; void *aligned_alloc(size_t alignment, size_t size)

XLIB aligned_alloc
XDEF memalign

LIB asm_aligned_alloc

aligned_alloc:
memalign:

   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   
   jp asm_aligned_alloc
