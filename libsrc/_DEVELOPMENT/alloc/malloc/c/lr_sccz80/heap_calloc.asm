
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

XLIB heap_calloc

LIB asm_heap_calloc

heap_calloc:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_heap_calloc
