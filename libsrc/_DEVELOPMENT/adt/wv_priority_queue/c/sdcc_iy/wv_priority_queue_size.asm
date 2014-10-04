
; size_t wv_priority_queue_size(wv_priority_queue_t *q)

SECTION seg_code_wv_priority_queue

PUBLIC _wv_priority_queue_size

EXTERN _wa_priority_queue_size

defc _wv_priority_queue_size = _wa_priority_queue_size

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_size.asm"
