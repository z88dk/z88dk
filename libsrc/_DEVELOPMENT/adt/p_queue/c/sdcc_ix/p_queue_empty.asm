
; int p_queue_empty(p_queue_t *q)

PUBLIC _p_queue_empty

EXTERN _p_forward_list_empty

_p_queue_empty:

   jp _p_forward_list_empty

   INCLUDE "adt/p_queue/z80/asm_p_queue_empty.asm"
