
; void *heap_init(void *heap, size_t size)

SECTION seg_code_malloc

PUBLIC heap_init

EXTERN asm_heap_init

heap_init:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_heap_init
