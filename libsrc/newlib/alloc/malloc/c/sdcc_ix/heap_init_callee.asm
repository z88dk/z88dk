
; void *heap_init_callee(void *heap, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_init_callee

EXTERN asm_heap_init

_heap_init_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_heap_init
