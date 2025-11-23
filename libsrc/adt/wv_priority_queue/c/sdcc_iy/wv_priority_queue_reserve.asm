
; int wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_reserve

EXTERN asm_wv_priority_queue_reserve

_wv_priority_queue_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_wv_priority_queue_reserve
