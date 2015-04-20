
; void *wv_priority_queue_data_fastcall(wv_priority_queue_t *q)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_data_fastcall

defc _wv_priority_queue_data_fastcall = asm_wv_priority_queue_data

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_data.asm"
