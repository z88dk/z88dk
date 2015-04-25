
; bv_priority_queue_t *
; bv_priority_queue_init_callee(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_init_callee

_bv_priority_queue_init_callee:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   push af

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_init.asm"
