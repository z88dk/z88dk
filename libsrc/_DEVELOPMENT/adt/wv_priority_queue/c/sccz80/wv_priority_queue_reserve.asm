
; int wv_priority_queue_reserve(wv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_reserve

EXTERN asm_wv_priority_queue_reserve

wv_priority_queue_reserve:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_wv_priority_queue_reserve
