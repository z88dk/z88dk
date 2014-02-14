
; void *heap_init(void *heap, size_t size)

XLIB heap_init

LIB asm_heap_init

heap_init:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   jp asm_heap_init
