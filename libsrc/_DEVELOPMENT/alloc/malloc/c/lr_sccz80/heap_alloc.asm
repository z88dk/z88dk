
; void *heap_alloc(void *heap, size_t size)

XLIB heap_alloc

LIB asm_heap_alloc

heap_alloc:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   
   jp asm_heap_alloc
