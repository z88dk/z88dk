
; void *heap_init(void *heap, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_init_callee

EXTERN asm_heap_init

heap_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_heap_init
