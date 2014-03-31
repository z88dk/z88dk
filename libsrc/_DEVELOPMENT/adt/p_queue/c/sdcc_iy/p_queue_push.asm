
; void p_queue_push(p_queue_t *q, void *item)

XDEF p_queue_push

LIB p_forward_list_alt_push_back

p_queue_push:

   jp p_forward_list_alt_push_back

   INCLUDE "adt/p_queue/z80/asm_p_queue_push.asm"
