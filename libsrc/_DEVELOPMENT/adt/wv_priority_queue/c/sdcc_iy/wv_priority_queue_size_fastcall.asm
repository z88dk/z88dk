
; size_t wv_priority_queue_size_fastcall(wv_priority_queue_t *q)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_size_fastcall

defc _wv_priority_queue_size_fastcall = asm_wv_priority_queue_size

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_size.asm"
