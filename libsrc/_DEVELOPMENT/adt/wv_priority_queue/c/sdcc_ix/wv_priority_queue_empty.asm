
; int wv_priority_queue_empty(wv_priority_queue_t *q)

SECTION seg_code_wv_priority_queue

PUBLIC _wv_priority_queue_empty

EXTERN _wa_priority_queue_empty

defc _wv_priority_queue_empty = _wa_priority_queue_empty

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_empty.asm"
