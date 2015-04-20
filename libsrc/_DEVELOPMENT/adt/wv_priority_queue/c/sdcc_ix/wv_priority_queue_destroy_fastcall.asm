
; void wv_priority_queue_destroy_fastcall(wv_priority_queue_t *q)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_destroy_fastcall

defc _wv_priority_queue_destroy = asm_wv_priority_queue_destroy

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_destroy.asm"
