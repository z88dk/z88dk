
; void heap_free_unlocked(void *heap, void *p)

XLIB heap_free_unlocked

LIB asm_heap_free_unlocked

heap_free_unlocked:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_heap_free_unlocked
