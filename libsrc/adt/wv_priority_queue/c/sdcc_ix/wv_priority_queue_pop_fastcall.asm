
; void *wv_priority_queue_pop_fastcall(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_pop_fastcall

EXTERN asm_wv_priority_queue_pop

defc _wv_priority_queue_pop_fastcall = asm_wv_priority_queue_pop
