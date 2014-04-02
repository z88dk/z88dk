
; void *p_queue_back(p_queue_t *q)

XDEF _p_queue_back

LIB _p_forward_list_alt_back

_p_queue_back:

   jp _p_forward_list_alt_back

   INCLUDE "adt/p_queue/z80/asm_p_queue_back.asm"
