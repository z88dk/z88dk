
; void *heap_alloc(void *heap, size_t size)

XLIB heap_alloc

LIB asm_heap_alloc

heap_alloc:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_heap_alloc
