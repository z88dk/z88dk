
; void *heap_realloc(void *heap, void *p, size_t size)

XLIB heap_realloc

LIB asm_heap_realloc

heap_realloc:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_heap_realloc
