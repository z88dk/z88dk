
; void *wv_priority_queue_pop_fastcall(wv_priority_queue_t *q)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_pop_fastcall

defc _wv_priority_queue_pop_fastcall = asm_wv_priority_queue_pop

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_pop.asm"
