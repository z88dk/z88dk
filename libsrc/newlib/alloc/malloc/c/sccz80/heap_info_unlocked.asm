
; void heap_info_unlocked(void *heap, void *callback)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_info_unlocked

EXTERN asm_heap_info_unlocked

heap_info_unlocked:

   pop af
   pop bc
   pop de

   push de
   push hl
   push af

   push ix
   push bc
   pop ix

   call asm_heap_info_unlocked
   pop ix
   ret
