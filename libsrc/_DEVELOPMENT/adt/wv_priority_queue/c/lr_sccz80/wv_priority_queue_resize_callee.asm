
; int wv_priority_queue_resize(wv_priority_queue_t *q, size_t n)

PUBLIC wv_priority_queue_resize_callee

EXTERN wa_priority_queue_resize_callee

;defc wv_priority_queue_resize_callee = wa_priority_queue_resize_callee

wv_priority_queue_resize_callee:

   jp wa_priority_queue_resize_callee

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_resize.asm"
