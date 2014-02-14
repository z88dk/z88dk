
; void *heap_galloc_unlocked(void *heap, void *p, int resize)

XLIB heap_galloc_unlocked

LIB asm_heap_galloc_unlocked

heap_galloc_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_heap_galloc_unlocked
