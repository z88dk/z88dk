
; void *heap_alloc_aligned(void *heap, size_t alignment, size_t size)

XLIB heap_alloc_aligned

LIB asm_heap_alloc_aligned

heap_alloc_aligned:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_heap_alloc_aligned
