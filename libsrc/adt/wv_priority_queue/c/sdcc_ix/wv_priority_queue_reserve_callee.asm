
; int wv_priority_queue_reserve_callee(wv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_reserve_callee

EXTERN asm_wv_priority_queue_reserve

_wv_priority_queue_reserve_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_wv_priority_queue_reserve
