
; int wv_priority_queue_empty_fastcall(wv_priority_queue_t *q)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_empty_fastcall

defc _wv_priority_queue_empty_fastcall = asm_wv_priority_queue_empty

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_empty.asm"
