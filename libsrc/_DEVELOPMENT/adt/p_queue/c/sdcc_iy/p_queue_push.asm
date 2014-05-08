
; void p_queue_push(p_queue_t *q, void *item)

PUBLIC _p_queue_push

EXTERN _p_forward_list_alt_push_back

_p_queue_push:

   jp _p_forward_list_alt_push_back

   INCLUDE "adt/p_queue/z80/asm_p_queue_push.asm"
