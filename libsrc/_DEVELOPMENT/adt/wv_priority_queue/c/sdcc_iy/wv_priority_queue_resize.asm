
; int wv_priority_queue_resize(wv_priority_queue_t *q, size_t n)

PUBLIC _wv_priority_queue_resize

EXTERN _wa_priority_queue_resize

_wv_priority_queue_resize:

   jp _wa_priority_queue_resize

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_resize.asm"
