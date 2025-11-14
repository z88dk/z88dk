
; void *heap_init(void *heap, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_init

EXTERN asm_heap_init

_heap_init:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_heap_init
