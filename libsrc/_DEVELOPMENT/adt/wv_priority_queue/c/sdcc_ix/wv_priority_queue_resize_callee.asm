
; int wv_priority_queue_resize_callee(wv_priority_queue_t *q, size_t n)

SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_resize_callee

EXTERN _wa_priority_queue_resize_callee

defc _wv_priority_queue_resize_callee = _wa_priority_queue_resize_callee

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_resize.asm"
