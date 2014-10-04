
; void *wv_priority_queue_top(wv_priority_queue_t *q)

SECTION seg_code_wv_priority_queue

PUBLIC _wv_priority_queue_top

EXTERN _wa_priority_queue_top

defc _wv_priority_queue_top = _wa_priority_queue_top

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_top.asm"
