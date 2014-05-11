
; void *heap_destroy(void *heap)

PUBLIC heap_destroy

;defc heap_destroy = asm_heap_destroy

heap_destroy:

   INCLUDE "alloc/malloc/z80/asm_heap_destroy.asm"
