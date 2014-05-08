
; void p_queue_clear(p_queue_t *q)

PUBLIC _p_queue_clear

EXTERN _p_forward_list_alt_init

_p_queue_clear:

   jp _p_forward_list_alt_init

   INCLUDE "adt/p_queue/z80/asm_p_queue_clear.asm"
