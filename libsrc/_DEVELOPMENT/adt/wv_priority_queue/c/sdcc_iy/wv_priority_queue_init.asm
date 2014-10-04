
; wv_priority_queue_t *
; wv_priority_queue_init(void *p, size_t capacity, size_t max_size, int (*compar)(const void *, const void *))

SECTION seg_code_wv_priority_queue

PUBLIC _wv_priority_queue_init

_wv_priority_queue_init:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   
   push ix
   push hl
   push bc
   push de
   push af

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_init.asm"
