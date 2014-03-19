
; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

XDEF wv_priority_queue_init_callee

wv_priority_queue_init_callee:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_wv_priority_queue_init.asm"
