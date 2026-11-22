
; size_t wv_priority_queue_max_size(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_max_size

EXTERN asm_wv_priority_queue_max_size

_wv_priority_queue_max_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_wv_priority_queue_max_size
