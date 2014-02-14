
; void *heap_alloc_fixed(void *heap, void *p, size_t size)

XLIB heap_alloc_fixed

LIB asm_heap_alloc_fixed

heap_alloc_fixed:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_heap_alloc_fixed
