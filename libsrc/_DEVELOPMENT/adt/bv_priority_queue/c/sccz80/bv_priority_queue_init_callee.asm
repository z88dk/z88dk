
; bv_priority_queue_t *
; bv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION seg_code_bv_priority_queue

PUBLIC bv_priority_queue_init_callee

bv_priority_queue_init_callee:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_init.asm"
