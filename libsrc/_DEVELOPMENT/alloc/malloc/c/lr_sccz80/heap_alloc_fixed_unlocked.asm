
; void *heap_alloc_fixed_unlocked(void *heap, void *p, size_t size)

XLIB heap_alloc_fixed_unlocked

LIB asm_heap_alloc_fixed_unlocked

heap_alloc_fixed_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_heap_alloc_fixed_unlocked
