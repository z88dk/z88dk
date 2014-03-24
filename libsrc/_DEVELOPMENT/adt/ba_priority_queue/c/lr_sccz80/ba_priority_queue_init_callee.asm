
; ba_priority_queue_t *
; ba_priority_queue_init(void *p, void *data, size_t capacity, int (*compar)(const void *, const void *))

XDEF ba_priority_queue_init_callee

ba_priority_queue_init_callee:

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_init.asm"
