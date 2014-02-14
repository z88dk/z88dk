
; void *heap_galloc(void *heap, void *p, int resize)

XLIB heap_galloc

LIB asm_heap_galloc

heap_galloc:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_heap_galloc
