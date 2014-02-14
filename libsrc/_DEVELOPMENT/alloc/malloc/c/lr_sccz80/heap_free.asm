
; void heap_free(void *heap, void *p)

XLIB heap_free

LIB asm_heap_free

heap_free:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_heap_free
