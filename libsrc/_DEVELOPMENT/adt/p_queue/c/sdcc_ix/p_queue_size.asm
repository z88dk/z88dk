
; size_t p_queue_size(p_queue_t *q)

PUBLIC _p_queue_size

EXTERN _p_forward_list_size

_p_queue_size:

   jp _p_forward_list_size

   INCLUDE "adt/p_queue/z80/asm_p_queue_size.asm"
